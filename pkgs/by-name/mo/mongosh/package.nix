{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_22,
}:

buildNpmPackage.override { nodejs = nodejs_22; } (finalAttrs: {
  pname = "mongosh";
  version = "2.8.2";

  src = fetchFromGitHub {
    owner = "mongodb-js";
    repo = "mongosh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GgXFbT0cgoo3wSe5jyE4sU977q4/xTOiEYILN0Kyl+4=";
  };

  npmDepsHash = "sha256-7o9UGK06wLAWDad6Xqq8o9cvJFSIkI2j8uHQxt77r9c=";

  patches = [
    ./disable-telemetry.patch
  ];

  npmFlags = [
    "--omit=optional"
    "--ignore-scripts"
  ];
  npmBuildScript = "compile";
  dontNpmInstall = true;
  installPhase = ''
    runHook preInstall
    npmWorkspace=packages/mongosh npmInstallHook
    cp -r packages configs $out/lib/node_modules/mongosh/
    rm $out/lib/node_modules/mongosh/node_modules/@mongosh/docker-build-scripts # dangling symlink
    runHook postInstall
  '';

  passthru = {
    # Version testing is skipped because upstream often forgets to update the version.

    updateScript = ./update.sh;
  };

  meta = {
    homepage = "https://www.mongodb.com/try/download/shell";
    changelog = "https://github.com/mongodb-js/mongosh/releases/tag/v${finalAttrs.version}";
    description = "MongoDB Shell";
    maintainers = with lib.maintainers; [ aaronjheng ];
    license = lib.licenses.asl20;
    mainProgram = "mongosh";
  };
})
