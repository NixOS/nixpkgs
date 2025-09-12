{
  lib,
  fetchzip,
  npm-lockfile-fix,
  buildNpmPackage,

  name,
  url,
  hash,
  npmDepsHash,
  patches ? [ ],
}:

buildNpmPackage {
  inherit name npmDepsHash patches;

  src = fetchzip {
    inherit url hash;
    postFetch = ''
      # Add missing integrity and resolved fields
      ${lib.getExe npm-lockfile-fix} $out/package-lock.json
    '';
  };

  postPatch = ''
    sed -i '/preinstall/d' package.json
  '';

  npmBuildScript = "dist";

  installPhase = ''
    runHook preInstall

    install -Dm444 -t $out publish/*.jpl

    runHook postInstall
  '';
}
