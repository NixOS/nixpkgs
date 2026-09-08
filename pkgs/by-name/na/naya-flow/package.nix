{
  callPackage,
  fetchurl,
  lib,
  stdenvNoCC,
}:

let
  inherit (stdenvNoCC.hostPlatform) system;
  sources = import ./sources.nix { inherit fetchurl; };

  pname = "naya-flow";

  passthru = {
    updateScript = ./update.sh;
  };

  meta = {
    description = "Customisation tool for modular Naya Create keyboard";
    homepage = "https://naya.tech/pages/naya-flow";
    # software-updates channel in Naya discord server
    changelog = "https://discord.com/channels/1049303598745538651/1367532319455449099";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      wrbbz
    ];
    platforms = [
      "aarch64-darwin"
    ];
    mainProgram = "nayaFlow";
  };
in
# There are plans on releasing Linux version.
# After that - linux.nix file will be added
callPackage ./darwin.nix {
  inherit pname passthru meta;
  inherit (sources.${system} or (throw "Unsupported system: ${system}")) version src;
}
