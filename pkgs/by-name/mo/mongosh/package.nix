{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "mongosh";
  version = "2.11.1";

  src = fetchFromGitHub {
    owner = "mongodb-js";
    repo = "mongosh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-h1OUm4fPYdDpU1K1a65Q5xeBHEryA1O05k0wr/x/yUQ=";
  };

  npmDepsHash = "sha256-/pHYIFybLfpj5B88T+B1stDnwMEOBIhIRX83ipSIAvo=";

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
