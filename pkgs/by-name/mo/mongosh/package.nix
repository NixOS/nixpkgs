{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  fetchpatch,
  libmongocrypt,
  krb5,
  testers,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "mongosh";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "mongodb-js";
    repo = "mongosh";

    # Tracking a few commits ahead of 2.5.1 to ensure the package-lock.json patch below applies
    #tag = "v${finalAttrs.version}";
    rev = "2163e8b10a77af18e0cedfa164526506c051593e";

    hash = "sha256-DYX8NqAISwzBpdilcv3YVrL72byXMeC4z/nLqd2nf2c=";
  };

  patches = [
    # https://github.com/mongodb-js/mongosh/pull/2452
    (fetchpatch {
      url = "https://github.com/mongodb-js/mongosh/commit/30f66260fce3e1744298d086bd2b54b2d2bfffbb.patch";
      hash = "sha256-c2QM/toeoagfhvuh4r+/5j7ZyV6DEr9brA9mXpEy1kM=";
    })

    ./disable-telemetry.patch
  ];

  npmDepsHash = "sha256-6uXEKAAGXxaODjXIszYml5Af4zSuEzy/QKdMgSzLD84=";
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
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://www.mongodb.com/try/download/shell";
    description = "MongoDB Shell";
    maintainers = with lib.maintainers; [ aaronjheng ];
    license = lib.licenses.asl20;
    mainProgram = "mongosh";
  };
})
