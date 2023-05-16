<<<<<<< HEAD
{ lib
, stdenv
, callPackage
, ...
}@args:

let
  extraArgs = removeAttrs args [ "callPackage" ];

=======
{ lib, stdenv, callPackage }:

let
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "spotify";

  meta = with lib; {
    homepage = "https://www.spotify.com/";
    description = "Play music from the Spotify music service";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];
<<<<<<< HEAD
    mainProgram = "spotify";
  };

in if stdenv.isDarwin
then callPackage ./darwin.nix (extraArgs // { inherit pname meta; })
else callPackage ./linux.nix (extraArgs // { inherit pname meta; })
=======
  };

in if stdenv.isDarwin
then callPackage ./darwin.nix { inherit pname meta; }
else callPackage ./linux.nix { inherit pname meta; }
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
