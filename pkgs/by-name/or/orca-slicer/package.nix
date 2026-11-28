{
  lib,
  stdenvNoCC,
  callPackage,
  withSystemd ? stdenvNoCC.hostPlatform.isLinux,
  withNvidiaGLWorkaround ? false,
}:
let
  pname = "orca-slicer";
  version = "2.4.2";

  meta = {
    description = "G-code generator for 3D printers (Bambu, Prusa, Voron, VzBot, RatRig, Creality, etc.)";
    homepage = "https://github.com/OrcaSlicer/OrcaSlicer";
    changelog = "https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/v${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      zhaofengli
      ovlach
      pinpox
      liberodark
      zraexy
    ];
    mainProgram = "orca-slicer";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
in
if stdenvNoCC.hostPlatform.isDarwin then
  callPackage ./darwin.nix { inherit pname version meta; }
else
  callPackage ./linux.nix {
    inherit
      pname
      version
      withSystemd
      withNvidiaGLWorkaround
      ;
    meta = meta // {
      platforms = lib.platforms.linux;
    };
  }
