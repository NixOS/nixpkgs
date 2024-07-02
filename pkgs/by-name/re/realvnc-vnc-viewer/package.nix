{ lib
, stdenv
, callPackage
}:
let
  pname = "realvnc-vnc-viewer";
  version = "7.12.0";

  meta = {
    description = "VNC remote desktop client software by RealVNC";
    homepage = "https://www.realvnc.com/en/connect/download/viewer/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = {
      fullName = "VNC Connect End User License Agreement";
      url = "https://static.realvnc.com/media/documents/LICENSE-4.0a_en.pdf";
      free = false;
    };
    maintainers = with lib.maintainers; [ emilytrau onedragon ];
    platforms = [ "x86_64-linux" ] ++ lib.platforms.darwin;
    mainProgram = "vncviewer";
  };
in
if stdenv.isDarwin then callPackage ./darwin.nix { inherit pname version meta; }
else callPackage ./linux.nix { inherit pname version meta; }
