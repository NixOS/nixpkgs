{ lib
, fetchFromGitHub
, stdenv
, rust
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "dyon";
  version = "0.49.1";

  src = fetchFromGitHub {
    owner = "PistonDevelopers";
    repo = pname;
    rev = "f61952a37850b5368b4eee7cefb58db7efe34b99";
    hash = "sha256-90RmN/jTs2plxnJ6YmLeUqminuR6JMvg/6JAhsbV+5Q=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  postPatch = ''
    cp ${cargoLock.lockFile} Cargo.lock
  '';

  env = {
    # Requires nightly features
    RUSTC_BOOTSTRAP = true;
  };

  cargoBuildFlags = [ "--examples" ];

  installPhase = ''
    runHook preInstall

    target=${rust.toRustTargetSpec stdenv.hostPlatform}
    mkdir -p $out/bin
    cp target/$target/release/examples/dyon target/$target/release/examples/dyonrun $out/bin

    runHook postInstall
  '';

  meta = with lib; {
    description = "Dynamically typed scripting language";
    homepage = "https://www.piston.rs/dyon-tutorial/";
    sourceProvenance = with sourceTypes; [ fromSource ];
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ prominentretail ];
    mainProgram = pname;
  };
}
