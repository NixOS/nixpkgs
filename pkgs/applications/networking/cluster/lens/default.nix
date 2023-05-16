{ stdenv, callPackage }:
<<<<<<< HEAD
=======

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
if stdenv.isDarwin then
  callPackage ./darwin.nix { }
else
  callPackage ./linux.nix { }
