{ lib, stdenv, callPackage }:

let
  pname = "spotify";

  meta = with lib; {
    homepage = "https://www.spotify.com/";
    description = "Play music from the Spotify music service";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];
  };

in if stdenv.isDarwin
then callPackage ./darwin.nix { inherit pname meta; }
else callPackage ./linux.nix { inherit pname meta; }
