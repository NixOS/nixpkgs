{
  lib,
  stdenvNoCC,
  callPackage,
}:
let
  p = if stdenvNoCC.hostPlatform.isDarwin then ./darwin.nix else ./linux.nix;
in
callPackage p {
  pname = "reaper-reapack-extension";
  version = "1.2.5";
  meta = {
    description = "Package manager for REAPER";
    homepage = "https://reapack.com/";
    license = with lib.licenses; [
      lgpl3Plus
      gpl3Plus
    ];
    maintainers = with lib.maintainers; [ pancaek ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}
