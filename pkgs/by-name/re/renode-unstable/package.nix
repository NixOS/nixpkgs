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
  version = "1.16.1-unstable-2026-03-31";

  src = fetchFromGitHub {
    owner = "renode";
    repo = "renode";
    rev = "9a65fb18c4ebdf32795150b44daa949977c6c124";
    hash = "sha256-Acx3kyk0vzB1df+8yvpj0fKgePtaolJ1c4nCicAD0Gs=";
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
