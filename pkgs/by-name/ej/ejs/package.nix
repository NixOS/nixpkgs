{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "ejs";
  version = "7.0.2";

  src = fetchFromGitHub {
    owner = "mde";
    repo = "ejs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jD19NEdSGnULGMMdM1lU8Pr3lZvfSvC1/Fa4LU2guqM=";
  };

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-1WTWEPaRgimw2bqHoWy1oFTTn7N3TQsSD5g0LPaZy+4=";

  buildPhase = ''
    runHook preBuild

    ./node_modules/.bin/jake build

    runHook postBuild
  '';

  meta = {
    description = "Embedded JavaScript templates";
    homepage = "https://ejs.co";
    license = lib.licenses.asl20;
    mainProgram = "ejs";
    maintainers = [ lib.maintainers.samirbgno ];
  };
})
