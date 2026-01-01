{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  nodejs,
  nodejs_20,
  makeWrapper,
  jre,
  fetchzip,
  buildNpmPackage,
<<<<<<< HEAD
  _experimental-update-script-combinators,
  nix-update-script,
  writeShellScript,
  gnugrep,
  nix-update,
  common-updater-scripts,
}:

let
  version = "0.29.1";
  apalacheVersion = "0.51.1";
  evaluatorVersion = "0.3.0";
=======
}:

let
  version = "0.25.1";
  apalacheVersion = "0.47.2";
  evaluatorVersion = "0.2.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  metaCommon = {
    description = "Formal specification language with TLA+ semantics";
    homepage = "https://quint-lang.org";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ bugarela ];
  };

  src = fetchFromGitHub {
    owner = "informalsystems";
    repo = "quint";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-lnvtyL4GKOyKdBDC5vevx5LgaiB7xTkfuN1rRTxKyv4=";
=======
    hash = "sha256-CYQesIoDlIGCKXIJ/hpZqOZBVd19Or5VEKVERchJz68=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  # Build the Quint CLI from source
  quint-cli = buildNpmPackage {
    pname = "quint-cli";
    inherit version src;

    nativeBuildInputs = [ nodejs_20 ];

    sourceRoot = "${src.name}/quint";

<<<<<<< HEAD
    npmDepsHash = "sha256-CBwovC7PTdjJHwL9lKRlJbl8rNjd9J3hVBFJz24+cbw=";
=======
    npmDepsHash = "sha256-FYNSr5B0/oJ4PbU/HUVqSdPG8kFvq4vRFnYwwdMf+jQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    npmBuildScript = "compile";

    dontNpmPrune = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/quint
      cp -r node_modules $out/share/quint
      cp -r dist $out/share/quint

      runHook postInstall
    '';

    meta = metaCommon // {
      description = "CLI for the Quint formal specification language";
    };
  };

  # Build the Rust evaluator from source
  quint-evaluator = rustPlatform.buildRustPackage {
    pname = "quint-evaluator";
    version = evaluatorVersion;
    inherit src;

    sourceRoot = "${src.name}/evaluator";

    # Skip tests during build, as many rust tests rely on the Quint CLI
    doCheck = false;

    cargoHash = "sha256-beWqUDaWWCbGL+V1LNtf35wZrIqWCCbFLYo5HCZF7FI=";

    meta = metaCommon // {
      description = "Evaluator for the Quint formal specification language";
    };
  };

  # Download Apalache. It runs on the JVM, so no need to build it from source.
  apalacheDist = fetchzip {
    url = "https://github.com/apalache-mc/apalache/releases/download/v${apalacheVersion}/apalache.tgz";
<<<<<<< HEAD
    hash = "sha256-xYQQH9XxPwf3+YmjiRs7XlW49LdHrEnMeuvd16Ir0B4=";
=======
    hash = "sha256-P0QOxB14OSlphqBALR1YL9WJ0XYaUYE/R52yZytVzds=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "quint";
  inherit version src;

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    makeWrapper ${nodejs}/bin/node $out/bin/quint \
      --add-flags "${quint-cli}/share/quint/dist/src/cli.js" \
      --set QUINT_HOME "$out/share/quint" \
      --prefix PATH : ${lib.makeBinPath [ jre ]}

    install -Dm755 ${quint-evaluator}/bin/quint_evaluator -t $out/share/quint/rust-evaluator-v${evaluatorVersion}/

    mkdir -p $out/share/quint/apalache-dist-${apalacheVersion}
    cp -r ${apalacheDist} $out/share/quint/apalache-dist-${apalacheVersion}/apalache
    chmod +x $out/share/quint/apalache-dist-${apalacheVersion}/apalache/bin/apalache-mc

    runHook postInstall
  '';

<<<<<<< HEAD
  passthru = {
    inherit
      quint-cli
      quint-evaluator
      apalacheDist
      apalacheVersion
      ;
    updateScript = _experimental-update-script-combinators.sequence [
      (nix-update-script {
        extraArgs = [
          "--subpackage"
          "quint-cli"
        ];
      })
      (writeShellScript "update" ''
        src=$(nix build --print-out-paths --no-link .#quint.src)
        QUINT_EVALUATOR_VERSION=$(${lib.getExe gnugrep} -m1 "const QUINT_EVALUATOR_VERSION" $src/quint/src/quintRustWrapper.ts | sed -E "s/.*= 'v?([^']+)'.*/\1/")
        ${lib.getExe nix-update} quint.quint-evaluator --version $QUINT_EVALUATOR_VERSION
        DEFAULT_APALACHE_VERSION_TAG=$(${lib.getExe gnugrep} "DEFAULT_APALACHE_VERSION_TAG" $src/quint/src/apalache.ts | sed -E "s/.*= '([^']+)'.*/\1/")
        ${lib.getExe' common-updater-scripts "update-source-version"} quint $DEFAULT_APALACHE_VERSION_TAG --version-key=apalacheVersion --source-key=apalacheDist --ignore-same-version --ignore-same-hash
      '')
    ];
  };

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  meta = metaCommon // {
    mainProgram = "quint";
  };
})
