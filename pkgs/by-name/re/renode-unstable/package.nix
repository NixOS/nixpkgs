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
    version = "1.17.0-unstable-2026-10-02";

    src = fetchFromGitHub {
      owner = "renode";
      repo = "renode";
      rev = "b039ed10ea66198afd6f68f2ec5a041e76e5e1dc";
      hash = "sha256-ico2g1YOPfM0wdKosUf1ul+u8JBA+N8qFHij57cmS34=";
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
