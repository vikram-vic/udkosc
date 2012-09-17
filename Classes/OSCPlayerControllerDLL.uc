/*******************************************************************************
	OSCPlayerController

	Creation date: 13/06/2010 00:58
	Copyright (c) 2010, beast
	<!-- $Id: NewClass.uc,v 1.1 2004/03/29 10:39:26 elmuerte Exp $ -->
*******************************************************************************/

class OSCPlayerControllerDLL extends OSCPlayerController
 DLLBind(oscpack_1_0_2);
 
var bool flying;
var bool oscmoving;
var int currentFingerTouches[5]; //borrowing this for multiparameter testing
var array<vector> fingerTouchArray; //borrowing this for multiparameter testing
var vector object1;
var vector object2;
var vector object3;
var vector object4;
var vector object5;
var Rotator RLeft, RRight;


/*
struct OSCMovementStruct
{
	var float vectorX;
	var float vectorY;
	var float vectorZ;	
}
*/

struct OSCMessageStruct
{
	var float test;
};

// borrowing this for multiparameter testing
struct OSCFingerController
{
	var float f1X;
	var float f1Y;
	var float f1Z;
	var float f1on;
	var float f2X;
	var float f2Y;
	var float f2Z;
	var float f2on;	
	var float f3X;
	var float f3Y;
	var float f3Z;
	var float f3on;	
	var float f4X;
	var float f4Y;
	var float f4Z;
	var float f4on;	
	var float f5X;
	var float f5Y;
	var float f5Z;
	var float f5on;	
};

//Global vars for this class
var OSCMessageStruct localOSCMessageStruct;
//var OSCMovementStruct localOSCMovementStruct;
var OSCFingerController localOSCFingerControllerStruct; // borrowing this for multiparameter testing



struct MyPlayerStruct
{
	var string PlayerName;
	var string PlayerPassword;
	var float Health;
	var float Score;
	var string testval;
};

// Struct for holding data from point-click targeting method. Sent via OSC to host
struct PointClickStruct
{
	var string Hostname;
	var int Port;
	var string TraceHit;
	var string TraceHit_class;
	var string TraceHit_class_outerName;
	var float LocX;
	var float LocY;
	var float LocZ;
	var string HitInfo_material;
	var string HitInfo_physmaterial;
	var string HitInfo_hitcomponent;
};

struct PointClickStructTEST
{
	var string Hostname;
	var int Port;
	var string TraceHit;
	var string TraceHit_class;
	var string TraceHit_class_outerName;
	var float LocX;
	var float LocY;
	var float LocZ;
	var string HitInfo_material;
	var string HitInfo_physmaterial;
	var string HitInfo_hitcomponent;
};

struct OSCScriptPlayerTeleportStruct
{
	var float teleport;
	var float teleportx;
	var float teleporty;
	var float teleportz;
};

struct OSCScriptPlayermoveStruct
{
	var float x;
	var float y;
	var float z;
	var float speed;
	var float jump;
	var float stop;
	var float id;
	var float fly;
	var float airspeed;
};

struct OSCScriptCameramoveStruct
{
	var float x;
	var float y;
	var float z;
	var float speed;
	var float pitch;
	var float yaw;
	var float roll;
};

struct OSCConsoleCommandStruct
{
	var float command;
};

// OSC Script structs
var OSCScriptPlayermoveStruct localOSCScriptPlayermoveStruct;
var OSCScriptCameramoveStruct localOSCScriptCameramoveStruct;
var OSCConsoleCommandStruct localOSCConsoleCommandStruct;
var OSCScriptPlayerTeleportStruct localOSCScriptPlayerTeleportStruct;

dllimport final function sendOSCmessageTest();
dllimport final function sendOSCmessageTest2();
dllimport final function sendOSCmessageTest3(out MyPlayerStruct a);
dllimport final function sendOSCmessageTest4(MyPlayerStruct a);
dllimport final function sendOSCpointClick(PointClickStruct a);	
dllimport final function sendOSCpointClickTEST(PointClickStructTEST a);	
dllimport final function OSCMessageStruct getOSCTest();
//dllimport final function OSCMovementStruct getOSCTest();
dllimport final function float getOSCTestfloat();
dllimport final function OSCFingerController getOSCFingerController(); //borrowing this for multiparameter testing
dllimport final function OSCScriptPlayermoveStruct getOSCScriptPlayermove();
dllimport final function OSCScriptCameramoveStruct getOSCScriptCameramove();
dllimport final function float getOSCConsoleCommand();
dllimport final function OSCScriptPlayerTeleportStruct getOSCScriptPlayerTeleport();

defaultproperties 
{
}

// borrowing this for multiparameter testing
simulated event PreBeginPlay()
{
	Super.PreBeginPlay();
	
//	OSCParameters = spawn(class'OSCParams');	
//	OSCHostname = OSCParameters.getOSCHostname();
//	OSCPort = OSCParameters.getOSCPort();	

	object1.X=0;
	object1.Y=0;
	object1.Z=0;
	object2.X=0;
	object2.Y=0;
	object2.Z=0;
	object3.X=0;
	object3.Y=0;
	object3.Z=0;
	object4.X=0;
	object4.Y=0;
	object4.Z=0;
	object5.X=0;
	object5.Y=0;
	object5.Z=0;
	
	fingerTouchArray[0]=object1;
	fingerTouchArray[1]=object2;
	fingerTouchArray[2]=object3;
	fingerTouchArray[3]=object4;
	fingerTouchArray[4]=object5;
	
//	OSCFingerSourceMax = vect(320.00000, 420.00000, 20.00000);
//	OSCFingerSourceMin = vect(0.00001, 0.00001, 7.40000);
//	OSCFingerWorldMax = vect(2000.00000, 2000.00000, 2300.00000);
//	OSCFingerWorldMin = vect(-2000.00000, -2000.00000, 0.00001);
//	OSCFingerOffsets = vect(-160.00000, -210.00000, 0.00001);	
}

function testInputData()
{
	`log("BBBBBBBBBBB");
	if(localOSCMessageStruct.test > 0.000)
	{
	`log("..."$localOSCMessageStruct.test$"...");
	}
}

simulated exec function OSCMove()
{
	if(oscmoving)
	{
		GotoState('PlayerWalking');
		Pawn.GotoState('PlayerWalking');
		oscmoving=false;
	}
	else
	{
		GotoState('OSCPlayerMoving');
		Pawn.GotoState('OSCPlayerMoving');
		oscmoving=true;
	}
}

simulated exec function FlyWalk()
{

	if(flying)
	{
		GotoState('PlayerWalking');
		bCheatFlying=false;
		flying=false;
	}
	else
	{
	  GotoState('PlayerFlying');
	  bCheatFlying=true;
	  flying=true;
	}
	
	//Pawn.toggleFlying();
}

reliable server function toggleFlying()
{	
	if(flying)
	{
		GotoState('PlayerWalking');
		bCheatFlying=false;
		flying=false;
	}
	else
	{
	  GotoState('PlayerFlying');
	  bCheatFlying=true;
	  flying=true;
	}
}


exec function NewFly()
{	
    //ServerFly();
	toggleFlying();
}

reliable server function ServerFly()
{
    Pawn.CheatFly();
}

exec function Use()
{
	Super(PlayerController).Use();
	`log("Fired Use Command");
}

simulated exec function setSeekingShockBallTargetClassName(int val)
{
	local string targetClassName;
	local string targetVolumeType;
	
	local OSCProj_SeekingShockBall pSSB;
	
	targetClassName="TriggerVolume";
	targetVolumeType="none";
	
	if(val==1)
	{
		targetClassName="OSCProj_ShockBall";
	}
	else if(val==2)
	{
		targetVolumeType="energy_post";
		`log("setSeekingShockBallTargetClassName=energy_post");
		
	} 
	else if(val==3) 
	{
		//targetVolumeType="counterweight";
		`log("setSeekingShockBallTargetClassName=osc_attractor");
		targetVolumeType="osc_attractor";
	}
	
	
	ForEach AllActors(class'OSCProj_SeekingShockBall', pSSB)
	{
		pSSB.hasSeekTarget=True;
		pSSB.seekTargetClassName=targetClassName;
		pSSB.seekTargetVolumeType=targetVolumeType;
		//pSSB.setSeekTarget();
	}
}

/*
exec function setRadiusSeekingShockBallfloat(float val)
{
	local OSCProj_SeekingShockBall pSR;
	
  	ForEach AllActors(class'OSCProj_SeekingShockBall', pSR)
	{
		pSR.setSeekRadius(val);
	}
}

exec function setRadiusSeekingRocket(float val)
{
	local OSCProj_SeekingRocket pSR;
	
  	ForEach AllActors(class'OSCProj_SeekingRocket', pSR)
	{
		pSR.setSeekRadius(val);
	}
}

exec function setRangeSeekingRocket(float val)
{	
	local OSCProj_SeekingRocket pSR;
	
  	ForEach AllActors(class'OSCProj_SeekingRocket', pSR)
	{
		pSR.setSeekRange(val);
	}
}

exec function setSpeedSeekingRocket(float val)
{
	local OSCProj_SeekingRocket pSR;
	
  	ForEach AllActors(class'OSCProj_SeekingRocket', pSR)
	{
		pSR.setSpeed(val);
	}
}
*/

simulated exec function setDrawScaleSeekingShockBall(float val)
{
	local OSCProj_SeekingShockBall pSB;
	
  	ForEach AllActors(class'OSCProj_SeekingShockBall', pSB)
	{
		pSB.SetDrawScale(val);
	}

}
simulated exec function increaseDrawScaleSeekingShockBall(float val)
{
	local OSCProj_SeekingShockBall pSB;
	
  	ForEach AllActors(class'OSCProj_SeekingShockBall', pSB)
	{
		pSB.SetDrawScale(pSB.DrawScale+val);
	}

}

simulated exec function decreaseDrawScaleSeekingShockBall(float val)
{
	local OSCProj_SeekingShockBall pSB;
	
  	ForEach AllActors(class'OSCProj_SeekingShockBall', pSB)
	{
		pSB.SetDrawScale(pSB.DrawScale-val);
	}

}


simulated exec function setFingerTouchSpeed(float val)
{
	local OSCProj_ShockBall pSB;
	
  	ForEach AllActors(class'OSCProj_ShockBall', pSB)
	{
		pSB.setFingerTouchSpeed(val);
	}
}

simulated exec function setSpeedSeekingShockBall(float val)
{
	local OSCProj_SeekingShockBall pSB;
	
  	ForEach AllActors(class'OSCProj_SeekingShockBall', pSB)
	{
		pSB.setSpeed(val);
	}
}

simulated exec function freezeShockBall()
{
	local OSCProj_ShockBall pSB;
	
  	ForEach AllActors(class'OSCProj_ShockBall', pSB)
	{
		pSB.freeze();
	}
}

simulated exec function setSpeedShockBall(float val)
{
	local OSCProj_ShockBall pSB;
	
  	ForEach AllActors(class'OSCProj_ShockBall', pSB)
	{
		pSB.setSpeed(val);
	}
}

simulated exec function setLockHomingTargets(bool val)
{

	local OSCProj_SeekingRocket pSB;
	local OSCProj_SeekingShockBall pSSB;
	
  	ForEach AllActors(class'OSCProj_SeekingRocket', pSB)
	{
		pSB.setLockHomingTargets(val);
	}

  	ForEach AllActors(class'OSCProj_SeekingShockBall', pSSB)
	{
		pSSB.setLockHomingTargets(val);
	}	
}

simulated exec function destroyShockBall(string id, optional bool big)
{
	local OSCProj_ShockBall pSB;
	local string currentName;
	
	bForceNetUpdate = TRUE; // Force replication
	
  	ForEach AllActors(class'OSCProj_ShockBall', pSB)
	{
		//pSB.ComboExplosion();
		//`log(pSB);
		currentName=""$psb$"";
		currentName -= "OSCProj_ShockBall_";
		//`log(currentName);
		if(currentName==id)
		{
			if(big)
				psb.ComboExplosion();
			else
				pSB.Shutdown();
		}
	}

}

// Destroy all current ShockBall Projectiles in game; optional boolean will cause large explosion rather than default simple shutdown call (no explosion)
simulated exec function destroyAllShockBalls(optional bool big) 
{
    local OSCProj_ShockBall pSB;

	bForceNetUpdate = TRUE; // Force replication
	
  	ForEach AllActors(class'OSCProj_ShockBall', pSB)
	{
		if(big)
			psb.ComboExplosion();
		else 
			pSB.Shutdown();
	}
}

// Destroys all projectiles currently in game with default UTProjectile Shutdown method
simulated exec function destroyAllProjectiles() 
{
    local UTProjectile pUT;

	bForceNetUpdate = TRUE; // Force replication
	
  	ForEach AllActors(class'UTProjectile', pUT)
	{
		pUT.Shutdown();
	}
}

simulated exec function setAllProjectileSpeed(int speed)
{
    local UTProjectile pUT;

  	ForEach AllActors(class'UTProjectile', pUT)
	{
		pUT.Speed = speed;
	}
}

exec function setOSCShockRifleFireInterval(float val)
{
    local UTWeapon wSR;

  	ForEach AllActors(class'UTWeapon', wSR)
	{
		//wSR.setFireInterval(1, val);
		//wSR.FireInterval=val;
	}
}

exec function setAllProjectileAccelRate(int val)
{
    local UTProjectile pUT;

  	ForEach AllActors(class'UTProjectile', pUT)
	{
		pUT.AccelRate = val;
	}

}
	
simulated exec function teleportPawn(float x, float y, float z)
{
	if( (Role==ROLE_Authority) || (RemoteRole<ROLE_SimulatedProxy) )
		teleportPawn_(x, y, z);
}

simulated reliable client function teleportPawn_(float x, float y, float z)
{

	local vector targetVector;
	
	bForceNetUpdate = TRUE; // Force replication
	
	targetVector.X = x;
	targetVector.Y = y;
	targetVector.Z = z;
	
	Pawn.SetLocation(targetVector);
}

simulated exec function moveAllProjectiles(float X, float Y, float Z) 
{
	if( (Role==ROLE_Authority) || (RemoteRole<ROLE_SimulatedProxy) )
		moveAllProjectiles_(X, Y, Z);
/*
    local UTProjectile pUT;
	local vector targetVector;
	
	bForceNetUpdate = TRUE; // Force replication
	
	targetVector.X = X;
	targetVector.Y = Y;
	targetVector.Z = Z;
	
  	ForEach AllActors(class'UTProjectile', pUT)
	{
		pUT.SetLocation(targetVector);
	}
*/
}

simulated reliable client function moveAllProjectiles_(float X, float Y, float Z)
{
    local UTProjectile pUT;
	local vector targetVector;
	
	bForceNetUpdate = TRUE; // Force replication
	
	targetVector.X = X;
	targetVector.Y = Y;
	targetVector.Z = Z;
	
  	ForEach AllActors(class'UTProjectile', pUT)
	{
		pUT.SetLocation(targetVector);
	}
}

simulated exec function setDirectionAllProjectiles(float X, float Y, float Z) 
{

    local UTProjectile pUT;
	local vector targetVector;
	targetVector.X = X;
	targetVector.Y = Y;
	targetVector.Z = Z;
	
  	ForEach AllActors(class'UTProjectile', pUT)
	{
		pUT.Velocity = (pUT.Speed)*targetVector;
		//pUT.MoveToward(targetVector);
	}
}

state OSCPlayerMoving
{

	exec function oscplayermoveTEST()
	{
	
		`log('IN OSCPLAYERMOVING');
	
	}
	
	function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, Rotator DeltaRot)
	{
	
		if (Pawn == none)
		{
			return;
		}
		
		Pawn.Acceleration = NewAccel;
	}
	
	function PlayerMove( float DeltaTime )
	{
		local vector			X,Y,Z, NewAccel;
		local eDoubleClickDir	DoubleClickMove;
		local rotator			OldRotation;
		local rotator			OSCRotation;
		local bool				bSaveJump;
		local bool				bOSCJump;
		local float				OSCJump;
		//local float 			OSCTeleport;
		//ROB HACKING - adding test vector pulling from OSC
		local vector			OSCVector, OSCX, OSCY, OSCZ;
		local float 			OSCGroundSpeed;
		local vector			OSCCamera;
		local float				OSCStop;

		OSCVector.X = localOSCScriptPlayermoveStruct.x;
		OSCVector.Y = localOSCScriptPlayermoveStruct.y;
		OSCVector.Z = localOSCScriptPlayermoveStruct.z;
		OSCGroundSpeed = localOSCScriptPlayermoveStruct.speed;
		OSCJump = localOSCScriptPlayermoveStruct.jump;
		OSCStop = localOSCScriptPlayermoveStruct.stop;
		//OSCTeleport = localOSCScriptPlayermoveStruct.teleport;
		
		//`log("OSCStop: "$OSCStop);
		
		//OSCVector.X = localOSCFingerControllerStruct.f1X;		
		//OSCVector.Y = localOSCFingerControllerStruct.f1Y;
		//OSCVector.Z = localOSCFingerControllerStruct.f1Z;		
		//OSCGroundSpeed = localOSCFingerControllerStruct.f1on;
		//OSCRotation = (Pitch=localOSCFingerControllerStruct.f2X, Roll=localOSCFingerControllerStruct.f2Y, Yaw=localOSCFIngerControllerStruct.f2Z);
		
//		OSCRotation.Pitch=localOSCFingerControllerStruct.f2X;
//		OSCRotation.Roll=localOSCFingerControllerStruct.f2Y;
//		OSCRotation.Yaw=localOSCFingerControllerStruct.f2Z;

		OSCRotation.Pitch=localOSCScriptCameramoveStruct.pitch;
		OSCRotation.Roll=localOSCScriptCameramoveStruct.roll;
		OSCRotation.Yaw=localOSCScriptCameramoveStruct.yaw;
		
		//`log("OSCRotation.Pitch = "$OSCRotation.Pitch);
		//`log("OSCRotation.Roll = "$OSCRotation.Roll);
		//`log("OSCRotation.Yaw = "$OSCRotation.Yaw);
		
//		OSCCamera.X = localOSCFingerControllerStruct.f3X;
//		OSCCamera.Y = localOSCFingerControllerStruct.f3Y;
//		OSCCamera.Z = localOSCFingerControllerStruct.f3Z;
		
		OSCCamera.X = localOSCScriptCameramoveStruct.x;
		OSCCamera.Y = localOSCScriptCameramoveStruct.y;
		OSCCamera.Z = localOSCScriptCameramoveStruct.z;

		OSCPawn(Pawn).setOSCCamera(OSCCamera);
		
		//OSCJump = localOSCFingerControllerStruct.f2on;
		
		//bOSCJump = false;
		
		if (OSCJump > 0.0) 
		{
			bOSCJump = true;
			bPressedJump = true;
		}
		
	
		`log("localOSCScriptPlayerTeleportStruct.teleport:  "$localOSCScriptPlayerTeleportStruct.teleport);
		`log("localOSCScriptPlayerTeleportStruct.teleportx:  "$localOSCScriptPlayerTeleportStruct.teleportx);
		`log("localOSCScriptPlayerTeleportStruct.teleporty:  "$localOSCScriptPlayerTeleportStruct.teleporty);
		`log("localOSCScriptPlayerTeleportStruct.teleportz:  "$localOSCScriptPlayerTeleportStruct.teleportz);
	
	if(localOSCScriptPlayerTeleportStruct.teleport > 0.0)
	{
		callTeleport();
	}		

		if( Pawn == None )
		{
			GotoState('Dead');
		}
		else
		{
			GetAxes(Pawn.Rotation,X,Y,Z);

			// Update acceleration.
			NewAccel = PlayerInput.aForward*X + PlayerInput.aStrafe*Y;
			NewAccel.Z = 0;
			NewAccel = Pawn.AccelRate * Normal(NewAccel);

			//ROB HACKING
			NewAccel = OSCVector;
			if(OSCStop == 1)
			{
				NewAccel.X = 0;
				NewAccel.Y = 0;
				NewAccel.Z = 0;
			}
			
			if (IsLocalPlayerController())
			{
				AdjustPlayerWalkingMoveAccel(NewAccel);
			}

			// Add OSC speed control
			Pawn.GroundSpeed = OSCGroundSpeed;
			
			DoubleClickMove = PlayerInput.CheckForDoubleClickMove( DeltaTime/WorldInfo.TimeDilation );

			// Update rotation.
			OldRotation = Rotation;
			SetRotation(OSCRotation);
			//UpdateRotation( DeltaTime );
			//Rotation = OSCRotation;
			
			bDoubleJump = false;

			// Add OSC Rotation
			Pawn.FaceRotation(OSCRotation, DeltaTime);
			//Pawn.FaceRotation(RInterpTo(OldRotation, OSCRotation, DeltaTIme, 90000, true), DeltaTime);
			
			//`log("bOSCJump: "$bOSCJump);
			//`log("OSCJump: "$OSCJump);
			
			// CROUCH
			// Pawn.ShouldCrouch(bDuck != 0);
			
				//`log("localOSCScriptPlayermoveStruct.teleport:  "$localOSCScriptPlayermoveStruct.teleport);
	//`log("localOSCScriptPlayermoveStruct.teleportx:  "$localOSCScriptPlayermoveStruct.teleportx);
	//`log("localOSCScriptPlayermoveStruct.teleporty:  "$localOSCScriptPlayermoveStruct.teleporty);
	//`log("localOSCScriptPlayermoveStruct.teleportz:  "$localOSCScriptPlayermoveStruct.teleportz);

			
			//Add OSC Jump and JumpZ
			if(bOSCJump)
			{
				//bPressedJump = true;
				Pawn.JumpZ = OSCJump;
				Pawn.DoJump(bUpdating);//bUpdating);
				//bPressedJump = false;
				//localOSCScriptPlayermoveStruct.jump = 0.0;
				bOSCJump = false;
				//OSCJump = 0.0;
			}
			
			if( bPressedJump && Pawn.CannotJumpNow() )
			{
				bSaveJump = true;
				bPressedJump = false;
			}
			else
			{
				bSaveJump = false;
			}

			if( Role < ROLE_Authority ) // then save this move and replicate it
			{
				ReplicateMove(DeltaTime, NewAccel, DoubleClickMove, OldRotation - OSCRotation);
			}
			else
			{
				ProcessMove(DeltaTime, NewAccel, DoubleClickMove, OldRotation - OSCRotation);
			}
			bPressedJump = bSaveJump;
			//bPressedJump = bOSCJump;
		}
	}
	
	/*
	function UpdateRotation( float DeltaTime )
	{
		local Rotator	DeltaRot, ViewRotation;
		
		ViewRotation = Rotation;
		If (Pawn !=none )
		{
			Pawn.SetDesiredRotation(ViewRotation);	
		}
		
		//Calculate Delta to be appled of VIewRotation
		DeltaRot.Yaw = 0;
		DeltaRot.Pitch = PlayerInput.aLookUp;
		ProcessViewRotation ( DeltaTime, ViewRotation, DeltaRot);
		SetRotation(ViewRotation);
		
	}
*/
	
	
	
}


exec function Test1() {
	//local int temp;
//	local string temp;
//	local double temp2;
//	local double temp3;
//	temp3 = 88;
//	temp2 = returnDouble();
//	temp = "3";//returnDouble(88);
//	ClientMessage(temp);
	sendOSCmessageTest();

	say("Just sent simple OSC message");
	ClientMessage("Location: "$Location.X);
}

exec function Test3_(string B) {

	local MyPlayerStruct tempVals;
	
	say("This is a test for Structs AAAAAAAAAAAAAAAAAAAA");
	tempVals.testval = B;
	
	//sendOSCmessageTest2();
	sendOSCmessageTest3(tempVals);
}

exec function Test4(string B) {

	local MyPlayerStruct tempVals;
	
	say("This is a test for Structs - "$B);
	tempVals.testval = B;
	
	//sendOSCmessageTest2();
	sendOSCmessageTest4(tempVals);
}

/**
* Removes this controller from the existing pawn and possesses a new one. (exec)
* 
* @param ClassName The classname of the WMPawn to possess
*/
exec function ChangePawns(string ClassName)
{
	local Pawn P;
	local Vector PawnLocation;
	local Rotator PawnRotation;
	local class <actor> NewClass;

	P = Pawn;
	PawnLocation = Pawn.Location;
	PawnRotation = Pawn.Rotation; 
	NewClass = class<actor>(DynamicLoadObject(ClassName, class'Class'));

	// Detach the current pawn from this controller and destroy it.
	UnPossess();
	P.Destroy(); 

	//spawn a new pawn and attach this controller
	P = Pawn(Spawn(NewClass, , ,PawnLocation,PawnRotation));

	//use false if you spawned a character and true for a vehicle
	Possess(P, false);
}

/*
out of CheatManager.uc:


exec function Summon( string ClassName )
{
local class<actor> NewClass;
local vector SpawnLoc;

`log( "Fabricate " $ ClassName );
NewClass = class<actor>( DynamicLoadObject( ClassName, class'Class' ) );
if( NewClass!=None )
{
if ( Pawn != None )
SpawnLoc = Pawn.Location;
else
SpawnLoc = Location;
Spawn( NewClass,,,SpawnLoc + 72 * Vector(Rotation) + vect(0,0,1) * 15 );
}
}
*/

/*
exec function ChangePawn()
{
//declare the variables
local OSCPawn p;
local vector l;
local rotator r; 

//set the variables 
p = Pawn;
l = Pawn.Location;
r = Pawn.Rotation; 

// get rid of the old pawn
UnPossess();
p.Destroy(); 

//spawn a new pawn and possess it
p = Spawn(class'OSCPawn', , ,l,r);

//use false if you spawned a character and true for a vehicle
Possess(p, false);
}
*/

/*
exec function RBGrav(float NewGravityScaling)
{
	WorldInfo.RBPhysicsGravityScaling = NewGravityScaling;
}
*/
/*
 * Print information about the thing we are looking at
 */
function showTargetInfo()
{
	
	Local vector loc, norm, end;
	Local TraceHitInfo hitInfo;
	Local Actor traceHit;
	local MyPlayerStruct tempVals;
	//local PointClickStruct pcStruct;
	local PointClickStructTEST pcStruct;
	
	end = Location + normal(vector(Rotation))*32768; // trace to "infinity"
	traceHit = trace(loc, norm, end, Location, true,, hitInfo);

	ClientMessage("");

	ClientMessage("In showTargetInfo:OSCPlayerControllerDLL");

	if (traceHit == none)
	{
		ClientMessage("Nothing found, try again.");
		return;
	}

	// Play a sound to confirm the information
	//ClientPlaySound(SoundCue'A_Vehicle_Cicada.SoundCues.A_Vehicle_Cicada_TargetLock');

	// By default only 4 console messages are shown at the time
/*	
 	ClientMessage("Hit: "$traceHit$"  class: "$traceHit.class.outer.name$"."$traceHit.class);
 	ClientMessage("Location: "$loc.X$","$loc.Y$","$loc.Z);
 	ClientMessage("Material: "$hitInfo.Material$"  PhysMaterial: "$hitInfo.PhysMaterial);
	ClientMessage("Component: "$hitInfo.HitComponent);
*/	


}
/**
 * Draw a crosshair. This function is called by the Engine.HUD class.
 */
function DrawHUD( HUD H )
{
	local float CrosshairSize;
	super.DrawHUD(H);

	H.Canvas.SetDrawColor(0,255,0,255);
	CrosshairSize = 4;

	H.Canvas.SetPos(H.CenterX - CrosshairSize, H.CenterY);
	H.Canvas.DrawRect(2*CrosshairSize + 1, 1);

	H.Canvas.SetPos(H.CenterX, H.CenterY - CrosshairSize);
	H.Canvas.DrawRect(1, 2*CrosshairSize + 1);
}

/*
 * The default state for the player controller
 */
auto state PlayerWaiting
{
	
	/*
	 * The function called when the user presses the fire key (left mouse button by default)
	 */
	exec function StartFire( optional byte FireModeNum )
	{
	
	//ClientMessage("In PlayerWaiting::StartFIre");
		super.StartFIre(FireModeNum);
		//showTargetInfo();
	}
}

simulated function setOSCFingerTouches__(float val)
{
	`log("CCCCCCCCCCCC");
	if(val > 0.000)
	{
	`log("..."$val$"...");
	}
}

simulated function setOSCFingerTouches(OSCFingerController fstruct)
{

	//`log("in setOSCFingerTouches");
	//`log("fstruct = "$fstruct.f1X);

//	currentFingerTouches[0]=fstruct.f1on;
//	currentFingerTouches[1]=fstruct.f2on;
//	currentFingerTouches[2]=fstruct.f3on;
//	currentFingerTouches[3]=fstruct.f4on;
//	currentFingerTouches[4]=fstruct.f5on;
	
//	if(fstruct.f1on>0.0)
//	{
	
//	`log("in setOSCFingerTouches");
//	`log("fstruct.f1X = "$fstruct.f1X);
//	`log("fstruct.f1Y = "$fstruct.f1Y);
//	`log("fstruct.f1Z = "$fstruct.f1Z);
//	`log("fstruct.f1on = "$fstruct.f1on);
//	`log("fstruct.f2X = "$fstruct.f2X);
//	`log("fstruct.f2Y = "$fstruct.f2Y);
//	`log("fstruct.f2Z = "$fstruct.f2Z);
//	`log("fstruct.f2on = "$fstruct.f2on);
/*	`log("fstruct.1fon: "$fstruct.f1on);
*/	
	
		fingerTouchArray[0].X=fstruct.f1X;	
		fingerTouchArray[0].Y=fstruct.f1Y;
		fingerTouchArray[0].Z=fstruct.f1Z;
//	}

//	if(fstruct.f2on>0.0)
//	{
/*
	`log("fstruct.f2X = "$fstruct.f2X);
	`log("fstruct.2fon: "$fstruct.f2on);
*/
		fingerTouchArray[1].X=fstruct.f2X;	
		fingerTouchArray[1].Y=fstruct.f2Y;
		fingerTouchArray[1].Z=fstruct.f2Z;
//	}
	
	if(fstruct.f3on>0.0)
	{
		fingerTouchArray[2].X=fstruct.f3X;	
		fingerTouchArray[2].Y=fstruct.f3Y;
		fingerTouchArray[2].Z=fstruct.f3Z;
	}
	
	if(fstruct.f4on>0.0)
	{
		fingerTouchArray[3].X=fstruct.f4X;	
		fingerTouchArray[3].Y=fstruct.f4Y;
		fingerTouchArray[3].Z=fstruct.f4Z;
	}
	
	if(fstruct.f5on>0.0)
	{
		fingerTouchArray[4].X=fstruct.f5X;	
		fingerTouchArray[4].Y=fstruct.f5Y;
		fingerTouchArray[4].Z=fstruct.f5Z;
	}
}

simulated function setOSCScriptCameramoveData(OSCScriptCameramoveStruct fstruct)
{
	localOSCScriptCameramoveStruct = fstruct;
	//`log("fstruct: "$fstruct);
	//`log("localOSCScriptCameramoveStruct.x:  "$localOSCScriptCameramoveStruct.x);
	//`log("localOSCScriptCameramoveStruct.y:  "$localOSCScriptCameramoveStruct.y);
	//`log("localOSCScriptCameramoveStruct.z:  "$localOSCScriptCameramoveStruct.z);

}

simulated function setOSCScriptPlayermoveData(OSCScriptPlayermoveStruct fstruct)
{
	localOSCScriptPlayermoveStruct = fstruct;

//	`log("localOSCScriptPlayermoveStruct.x:  "$localOSCScriptPlayermoveStruct.x);
//	`log("localOSCScriptPlayermoveStruct.y:  "$localOSCScriptPlayermoveStruct.y);
//	`log("localOSCScriptPlayermoveStruct.z:  "$localOSCScriptPlayermoveStruct.z);
	//`log("localOSCScriptPlayermoveStruct.teleport:  "$localOSCScriptPlayermoveStruct.teleport);

	//localOSCScriptPlayermoveStruct.x = getOSCScriptPlayermove();
}

simulated function setOSCScriptPlayerTeleportData(OSCScriptPlayerTeleportStruct fstruct)
{
	localOSCScriptPlayerTeleportStruct = fstruct;

}

simulated function callConsoleCommand(float val)//OSCConsoleCommandStruct fstruct)
{
	local int currentVal;
	currentVal = val;//.appTrunc();//appTrunc(val);
	
	//localOSCConsoleCommandStruct = fstruct;
	`log("ConsoleCommand: "$currentVal);
	//`log("ConsoleCommand: "$localOSCConsoleCommandStruct.command);
	//`log("ConsoleCommand Value : "$localOSCConsoleCommandStruct.value);
	//ConsoleCommand($localOSCConsoleCommandStruct.command);
	if (currentVal == 1) 
	{
		`log("ConsoleCommand *********************************************************************************************************************************************** ");
	  ConsoleCommand("behindview");
	}
}

simulated function callTeleport()
{
	`log("IN TELEPORT **************************************************************");

	
	if(localOSCScriptPlayerTeleportStruct.teleport == 1.0)
	{
		`log("TELEPORT == 1.0");
		teleportPawn_(localOSCScriptPlayerTeleportStruct.teleportx, localOSCScriptPlayerTeleportStruct.teleporty, localOSCScriptPlayerTeleportStruct.teleportz);
	}
}


// TODO: hook this to generic OSC call, string title + params can be passed in via OSC
/*
function OSCCallExecCommand(string val)
{
	ConsoleCommand(val);
}
*/

event PlayerTick( float DeltaTime )
{
	// Add OSC Input call to the player Tick, called each tick from PlayerController
	localOSCMessageStruct.test = getOSCTestfloat();
	//localOSCMovementStruct.vectorX = getOSCTestfloat();

	
	
	// Generic OSCConsoleCommand call
//	if(localOSCScriptPlayermoveStruct.teleport == 1.0)
//	{
//		`log("TELEPORT == 1.0");
//		//teleportPawn_(localOSCScriptPlayermoveStruct.teleportx, localOSCScriptPlayermoveStruct.teleporty, localOSCScriptPlayermoveStruct.teleportz);
//	}
	
	if(oscmoving)
	{
	
		//getOSCConsoleCommand();
		callConsoleCommand(getOSCConsoleCommand());
		//`log("CONSOLE COMMAND: "$getOSCConsoleCommand());
	
		localOSCFingerControllerStruct = getOSCFingerController();
		setOSCFingerTouches(localOSCFingerControllerStruct);
		// OSC Script data for OSC control over pawns and camera
		//`log("Before setSCScriptPlayermoveData");
		setOSCScriptPlayermoveData(getOSCScriptPlayermove());
		setOSCScriptCameramoveData(getOSCScriptCameramove());
		setOSCScriptPlayerTeleportData(getOSCScriptPlayerTeleport());
		
		//`log("After setSCScriptPlayermoveData");		
		//callTeleport();
	}
	
	testInputData(); // rkh testing input data
	
	Super.PlayerTick(DeltaTime);
	
}
