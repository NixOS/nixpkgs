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
}:

let
  version = "0.25.1";
  apalacheVersion = "0.47.2";
  evaluatorVersion = "0.2.0";

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
    hash = "sha256-CYQesIoDlIGCKXIJ/hpZqOZBVd19Or5VEKVERchJz68=";
  };

  # Build the Quint CLI from source
  quint-cli = buildNpmPackage {
    pname = "quint-cli";
    inherit version src;

    nativeBuildInputs = [ nodejs_20 ];

    sourceRoot = "${src.name}/quint";

    npmDepsHash = "sha256-FYNSr5B0/oJ4PbU/HUVqSdPG8kFvq4vRFnYwwdMf+jQ=";

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
    hash = "sha256-P0QOxB14OSlphqBALR1YL9WJ0XYaUYE/R52yZytVzds=";
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

  meta = metaCommon // {
    mainProgram = "quint";
  };
})
