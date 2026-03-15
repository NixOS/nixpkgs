{
  stdenvNoCC,
  lib,
  callPackage,
  qt6Packages,
  ffmpeg-full,

}:

let
  pname = "obs-studio";
  version = "32.0.4";

  meta = {
    description = "Free and open source software for video recording and live streaming";
    longDescription = ''
      This project is a rewrite of what was formerly known as "Open Broadcaster
      Software", software originally designed for recording and streaming live
      video content, efficiently
    '';
    homepage = "https://obsproject.com";
  };
in
if stdenvNoCC.isDarwin then
  callPackage ./darwin.nix { inherit pname version meta; }
else
  qt6Packages.callPackage ./linux.nix {
    inherit pname version meta;
    ffmpeg = ffmpeg-full;
  }
