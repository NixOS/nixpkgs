{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "mongosh";
  version = "2.14.1";

  src = fetchFromGitHub {
    owner = "mongodb-js";
    repo = "mongosh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1e/AgyKLRKDKLA0ETHYEtrqOP4aVE13dY31NrXFTS54=";
  };

  npmDepsHash = "sha256-QF8nm8XwkYrFLSfLbz8hJRxPSJvMQUkpEv7AhYzgqjY=";

  postPatch = ''
    # Disable telemetry by default; users can still opt in via enableTelemetry().
    substituteInPlace packages/cli-repl/src/cli-repl.ts \
      --replace-fail "enableTelemetry: true" "enableTelemetry: false"
  '';

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
