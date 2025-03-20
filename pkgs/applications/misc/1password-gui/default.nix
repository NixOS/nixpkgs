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

  versions = builtins.fromJSON (builtins.readFile ./versions.json);
  hostOs = if stdenv.hostPlatform.isLinux then "linux" else "darwin";
  version = versions."${channel}-${hostOs}" or (throw "unknown channel-os ${channel}-${hostOs}");

  sources = builtins.fromJSON (builtins.readFile ./sources.json);

  src = fetchurl {
    inherit
      (sources.${channel}.${stdenv.system} or (throw "unsupported system ${stdenv.hostPlatform.system}"))
      url
      hash
      ;
  };

  meta = {
    # Requires to be installed in "/Application" which is not possible for now (https://github.com/NixOS/nixpkgs/issues/254944)
    broken = stdenv.hostPlatform.isDarwin;
    description = "Multi-platform password manager";
    homepage = "https://1password.com/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      khaneliman
      timstott
      savannidgerinel
      sebtm
    ];
    platforms = builtins.attrNames sources.${channel};
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
