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
  version = "1.16.1-unstable-2026-04-12";

  src = fetchFromGitHub {
    owner = "renode";
    repo = "renode";
    rev = "1ad93ffd5b0f2d67ff04f593de6318d12379d897";
    hash = "sha256-MOCjxn4VB9uaq5UkHbZiGOdJDetUP816lnuPN0kXjTM=";
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
