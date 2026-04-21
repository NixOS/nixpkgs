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
  version = "1.16.1-unstable-2026-04-20";

  src = fetchFromGitHub {
    owner = "renode";
    repo = "renode";
    rev = "8fd79472e778216a6bbf5e40bf79ce54a76f7a7b";
    hash = "sha256-e05IaXImpDWxxwmmI2o6YCnZ9Tp7wtP2Y7786AeoW40=";
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
