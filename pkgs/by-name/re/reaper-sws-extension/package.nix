{
  lib,
  stdenvNoCC,
  callPackage,
}:
let
  p = if stdenvNoCC.hostPlatform.isDarwin then ./darwin.nix else ./linux.nix;
in
callPackage p {

  pname = "reaper-sws-extension";
  version = "2.14.0.7";
  meta = {
    description = "Reaper Plugin Extension";
    longDescription = ''
      The SWS / S&M extension is a collection of features that seamlessly integrate into REAPER, the Digital Audio Workstation (DAW) software by Cockos, Inc.
      It is a collaborative and open source project.
    '';
    homepage = "https://www.sws-extension.org/";
    maintainers = with lib.maintainers; [ pancaek ];
    license = lib.licenses.mit;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}
