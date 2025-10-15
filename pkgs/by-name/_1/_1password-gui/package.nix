{
  stdenv,
  callPackage,
  channel ? "stable",
  fetchurl,
  lib,
  # This is only relevant for Linux, so we need to pass it through
  polkitPolicyOwners ? [ ],
}:

let
  pname = "1password";

  hostOs = stdenv.hostPlatform.parsed.kernel.name;
  hostArch = stdenv.hostPlatform.parsed.cpu.name;
  sources = builtins.fromJSON (builtins.readFile ./sources.json);

  sourcesChan = sources.${channel} or (throw "unsupported channel ${channel}");
  sourcesChanOs = sourcesChan.${hostOs} or (throw "unsupported OS ${hostOs}");
  sourcesChanOsArch =
    sourcesChanOs.sources.${hostArch} or (throw "unsupported architecture ${hostArch}");

  inherit (sourcesChanOs) version;
  src = fetchurl {
    inherit (sourcesChanOsArch) url hash;
  };

  meta = {
    description = "Multi-platform password manager";
    homepage = "https://1password.com/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      khaneliman
      timstott
      savannidgerinel
      sebtm
      bdd
      iedame
    ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    mainProgram = "1password";
  };

in
if stdenv.hostPlatform.isDarwin then
  callPackage ./darwin.nix {
    inherit
      pname
      version
      src
      meta
      ;
  }
else
  callPackage ./linux.nix {
    inherit
      pname
      version
      src
      meta
      polkitPolicyOwners
      ;
  }
