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
  version = "1.16.1-unstable-2026-04-03";

  src = fetchFromGitHub {
    owner = "renode";
    repo = "renode";
    rev = "a5e76fbb6f3b2a15e6b1e3bfe021fdc2619f773a";
    hash = "sha256-FCeZ/6Dp/IgFgaKu589rMAOk0NIisR4uJyCKcuSsM90=";
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
