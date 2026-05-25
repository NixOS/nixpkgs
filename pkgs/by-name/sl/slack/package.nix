{
  callPackage,
  fetchurl,
  lib,
  stdenvNoCC,
}:

let
  inherit (stdenvNoCC.hostPlatform) system;
  sources = import ./sources.nix { inherit fetchurl; };

  pname = "slack";

  passthru = {
    updateScript = ./update.sh;
  };

  meta = {
    description = "Desktop client for Slack";
    homepage = "https://slack.com";
    changelog = "https://slack.com/release-notes";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      mmahut
      prince213
      teutat3s
    ];
    platforms = [
      "x86_64-darwin"
      "x86_64-linux"
      "aarch64-darwin"
    ];
    mainProgram = "slack";
  };
in
callPackage (if stdenvNoCC.hostPlatform.isDarwin then ./darwin.nix else ./linux.nix) {
  inherit pname passthru meta;
  inherit (sources.${system} or (throw "Unsupported system: ${system}")) version src;
}
