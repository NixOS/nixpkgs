{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  rustPlatform,
  makeWrapper,
  jre,
  fetchurl,
  buildNpmPackage,
  pkgs,
}:

let
  quintVersion = "0.25.1";
  apalacheVersion = "0.47.2";
  evaluatorVersion = "0.2.0";

  quintSrc = fetchFromGitHub {
    owner = "informalsystems";
    repo = "quint";
    rev = "v${quintVersion}";
    sha256 = "sha256-CYQesIoDlIGCKXIJ/hpZqOZBVd19Or5VEKVERchJz68=";
  };

  # Build the Quint CLI from source
  quintCLI = buildNpmPackage {
    name = "Quint CLI";

    buildInputs = with pkgs; [
      nodejs_20
    ];

    src = "${quintSrc}/quint";
    npmDepsHash = "sha256-FYNSr5B0/oJ4PbU/HUVqSdPG8kFvq4vRFnYwwdMf+jQ=";
    npmBuildScript = "compile";

    dontNpmPrune = true;
    installPhase = ''
      mkdir -p $out/share/quint
      cp -r node_modules $out/share/quint/
      cp -r dist $out/share/quint/
    '';
  };

  # Build the Rust evaluator from source
  rustEvaluator = rustPlatform.buildRustPackage {
    pname = "quint-evaluator";
    version = evaluatorVersion;
    src = "${quintSrc}/evaluator";

    # Skip tests during build, as many rust tests rely on the Quint CLI
    doCheck = false;

    useFetchCargoVendor = true;
    cargoHash = "sha256-beWqUDaWWCbGL+V1LNtf35wZrIqWCCbFLYo5HCZF7FI=";
  };

  # Download Apalache. It runs on the JVM, so no need to build it from source.
  apalacheDist = fetchurl {
    url = "https://github.com/apalache-mc/apalache/releases/download/v${apalacheVersion}/apalache.tgz";
    sha256 = "sha256-2uQlLspS+8UXz3uwJEv768thXqpcmDPCff3WMCXqI6o=";
  };
in
stdenv.mkDerivation rec {
  pname = "quint";
  version = quintVersion;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre ];

  src = quintSrc;

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    # Create executable wrapper for the CLI
    makeWrapper ${nodejs}/bin/node $out/bin/quint \
      --add-flags "${quintCLI}/share/quint/dist/src/cli.js" \
      --set QUINT_HOME "$out/.quint" \
      --prefix PATH : ${lib.makeBinPath [ jre ]}

    # Install evaluator
    mkdir -p $out/.quint/rust-evaluator-v${evaluatorVersion}
    install -Dm755 ${rustEvaluator}/bin/quint_evaluator $out/.quint/rust-evaluator-v${evaluatorVersion}/

    # Install Apalache
    mkdir -p $out/.quint/apalache-dist-${apalacheVersion}
    tar xzf ${apalacheDist} -C $out/.quint/apalache-dist-${apalacheVersion}
    chmod +x $out/.quint/apalache-dist-${apalacheVersion}/apalache/bin/apalache-mc

    runHook postInstall
  '';

  meta = {
    description = "Formal specification language with TLA+ semantics";
    homepage = "https://quint-lang.org";
    license = lib.licenses.asl20;
    mainProgram = "quint";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      bugarela
    ];
  };
}
