{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_24,
}:

buildNpmPackage.override { nodejs = nodejs_24; } (finalAttrs: {
  pname = "mongosh";
  version = "2.9.2";

  src = fetchFromGitHub {
    owner = "mongodb-js";
    repo = "mongosh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mwc9Mv8BJgI/7DzUH6QwHsWzgAquB8ehmnElM5+mYuI=";
  };

  npmDepsHash = "sha256-xI+6a0sMuZmij46N5aqsprLLiVaSZifGW8tMq189fww=";

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
