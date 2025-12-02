{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "mongosh";
  version = "2.5.10";

  src = fetchFromGitHub {
    owner = "mongodb-js";
    repo = "mongosh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-N1uAIgEX44RSFJTivOpASKiab+Jr0N0Mo+olt000uK4=";
  };

  npmDepsHash = "sha256-/8qw9dVPHAuyQZWdDq+jhP7NMBwTbvMqv/PtwXJEQuo=";

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
    description = "MongoDB Shell";
    maintainers = with lib.maintainers; [ aaronjheng ];
    license = lib.licenses.asl20;
    mainProgram = "mongosh";
  };
})
