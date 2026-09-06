{
  fetchFromGitHub,
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
  version = "1.16.1-unstable-2026-04-29";

  src = fetchFromGitHub {
    owner = "renode";
    repo = "renode";
    rev = "67b2b9ce5e6162e60b4b46a21e0e5b696a3cdb45";
    hash = "sha256-MPcSEijyfC49l96G7y220eljpEdz03uv9LrDm/LXHA0=";
    fetchSubmodules = true;
  };

  nugetDeps = ./deps.json;

  prePatch = ''
    sed -i 's/AssemblyVersion("%VERSION%.*")/AssemblyVersion("${normalizedVersion version}.0")/g' src/Renode/Properties/AssemblyInfo.template
    sed -i 's/AssemblyInformationalVersion("%INFORMATIONAL_VERSION%")/AssemblyInformationalVersion("${src.rev}")/g' src/Renode/Properties/AssemblyInfo.template
    mv src/Renode/Properties/AssemblyInfo.template src/Renode/Properties/AssemblyInfo.cs
  '';

  passthru = old.passthru // {
    updateScript = ./update.sh;
  };
})
