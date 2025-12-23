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
  version = "1.16.0-unstable-2025-12-11";

  src = fetchFromGitHub {
    owner = "renode";
    repo = "renode";
    rev = "e61a4063ec362b099704e6d8f9734cdf792aeeb0";
    hash = "sha256-ucQguZZSNKa0nEOTCdcLyDlaBnRgi/7Yb6VunNG/iSg=";
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
