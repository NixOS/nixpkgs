{
  dotnetCorePackages,
  fetchFromGitHub,
  lib,
  renode,
  writeShellScript,
}:

let
  nugetDeps = map dotnetCorePackages.fetchNupkg (lib.importJSON ./deps.json);
in
renode.overrideAttrs (
  finalAttrs: old: {
    pname = "renode-unstable";
    version = "1.17.0-unstable-2026-09-23";

    src = fetchFromGitHub {
      owner = "renode";
      repo = "renode";
      rev = "c69f1a823e565d8f713ad669e48cc1e2ae7a2680";
      hash = "sha256-la+xH6a0sJPIPdqGQwPAH9TyW/NAo/CU3B0lyTrmlL0=";
      fetchSubmodules = true;
    };

    buildInputs = lib.subtractLists old.passthru.nugetDeps old.buildInputs ++ nugetDeps;

    passthru = old.passthru // {
      inherit nugetDeps;
      fetch-deps = writeShellScript "${finalAttrs.finalPackage.name}-fetch-deps" ''
        exec ${old.passthru.fetch-deps} "''${1:-${toString ./deps.json}}"
      '';
      updateScript = ./update.sh;
    };
  }
)
