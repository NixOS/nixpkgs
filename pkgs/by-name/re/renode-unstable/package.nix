{
  fetchFromGitHub,
  nix-update-script,
  renode,
  lib,
}:
let
  normalizedVersion =
    v:
    let
      parts = lib.splitString "-" v;
      result = builtins.head parts;
    in
    result;
in
renode.overrideAttrs (old: rec {
  pname = "renode-unstable";
  version = "1.16.0-unstable-2025-08-08";

  src = fetchFromGitHub {
    owner = "renode";
    repo = "renode";
    rev = "194d90650a9337a05cd81e8855474773d23d4396";
    hash = "sha256-oRtbjup5RKbVzKMTa0yiY1gGhDqUrQ4N3SgwQ7lm8Ho=";
    fetchSubmodules = true;
  };

  prePatch = ''
    sed -i 's/AssemblyVersion("%VERSION%.*")/AssemblyVersion("${normalizedVersion version}.0")/g' src/Renode/Properties/AssemblyInfo.template
    sed -i 's/AssemblyInformationalVersion("%INFORMATIONAL_VERSION%")/AssemblyInformationalVersion("${src.rev}")/g' src/Renode/Properties/AssemblyInfo.template
    mv src/Renode/Properties/AssemblyInfo.template src/Renode/Properties/AssemblyInfo.cs
  '';

  passthru = old.passthru // {
    updateScript = nix-update-script {
      extraArgs = [
        "--version=branch"
      ];
    };
  };
})
