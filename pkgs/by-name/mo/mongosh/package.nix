{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  testers,
  nix-update-script,
  fetchpatch,
}:

buildNpmPackage (finalAttrs: {
  pname = "mongosh";
  version = "2.5.2";

  src = fetchFromGitHub {
    owner = "mongodb-js";
    repo = "mongosh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0rol41XNdpfVRGY8KXFmQ0GHg5QqgnCaF21ZFyxfKeQ=";
  };

  npmDepsHash = "sha256-J4/CU+gdT/qecM1JwafLBewQjYdaONq/k4ax3Jw34XY=";

  patches = [
    ./disable-telemetry.patch

    # For tagged version 2.5.2
    (fetchpatch {
      url = "https://github.com/mongodb-js/mongosh/commit/8e775b58b95f1d7c0a3de9c677e957a40213da6a.patch";
      hash = "sha256-Q80QuzC7JN6uqyjk7YuUljXm+365AwYRV5cct9TefUc=";
    })
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
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "^v(\\d+\\.\\d+\\.\\d+)$"
      ];
    };
  };

  meta = {
    homepage = "https://www.mongodb.com/try/download/shell";
    description = "MongoDB Shell";
    maintainers = with lib.maintainers; [ aaronjheng ];
    license = lib.licenses.asl20;
    mainProgram = "mongosh";
  };
})
