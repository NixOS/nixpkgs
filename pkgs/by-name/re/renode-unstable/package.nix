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
    version = "1.17.0-unstable-2026-10-12";

    src = fetchFromGitHub {
      owner = "renode";
      repo = "renode";
      rev = "59f8f5d0b1efdbacf1800dbef55fc1959c9a4cc8";
      hash = "sha256-XllgBdr2Aqq+SU5mYf6LhELNpHVM1JrkeWL6kQy0x0g=";
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
