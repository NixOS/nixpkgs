{
  url,
  hash,
  patches ? [ ],
}:

{
  lib,
  fetchzip,
  npm-lockfile-fix,
  buildNpmPackage,
  importNpmLock,
}:

let
  src = fetchzip {
    inherit url hash;
    postFetch = ''
      # Add missing integrity and resolved fields
      ${lib.getExe npm-lockfile-fix} $out/package-lock.json
    '';
  };
  package = (lib.importJSON (src + "/package.json")) // {
    scripts.preinstall = "";
  };
in

buildNpmPackage {
  inherit src patches;
  inherit (package) version;

  pname = package.name;

  npmDeps = importNpmLock {
    npmRoot = src;
    inherit package;
  };

  inherit (importNpmLock) npmConfigHook;

  npmBuildScript = "dist";

  installPhase = ''
    runHook preInstall

    install -Dm444 -t $out publish/*.jpl

    runHook postInstall
  '';
}
