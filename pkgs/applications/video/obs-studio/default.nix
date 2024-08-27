{
  stdenvNoCC,
  lib,
  callPackage,
  qt6Packages,
  ffmpeg-full,
}:

let

  pname = "obs-studio";
  version = "30.2.3";

  meta = with lib; {
    description = "Free and open source software for video recording and live streaming";
    longDescription = ''
      This project is a rewrite of what was formerly known as "Open Broadcaster
      Software", software originally designed for recording and streaming live
      video content, efficiently
    '';
    homepage = "https://obsproject.com";
    platforms = [ "x86_64-linux" "i686-linux" "aarch64-linux" ] ++ platforms.darwin;
  };
in if stdenvNoCC.isDarwin
then callPackage ./darwin.nix { inherit pname version meta; }
else qt6Packages.callPackage ./linux.nix { inherit pname version meta; ffmpeg = ffmpeg-full; }
