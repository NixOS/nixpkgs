{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  protobuf,
  libgit2,
  sqlite,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "breez-sdk-spark";
  # Must match github.com/breez/breez-sdk-spark-go in BitBox's go.mod.
  version = "0.28.0";

  src = fetchFromGitHub {
    owner = "breez";
    repo = "spark-sdk";
    tag = finalAttrs.version;
    hash = "sha256-x8lRqroW5Y3x39jcKF8MNeSMCT/hWMux6Bs6StRuQUY=";
  };

  cargoHash = "sha256-r7VIeYVXNx2ObUAXxAqncbsr2x16EOvjAy+l5MU/GjE=";

  # Let the Nix linker wrapper set RPATHs without retaining the Rust toolchain.
  env.CARGO_PROFILE_RELEASE_RPATH = "false";

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];

  buildInputs = [
    libgit2
    sqlite
  ];

  cargoBuildFlags = [
    "-p"
    "breez-sdk-spark-bindings"
    "--lib"
  ];

  # The bindings crate does not contain tests.
  doCheck = false;

  installPhase = ''
    runHook preInstall
    install -Dm755 target/${stdenv.hostPlatform.rust.rustcTarget}/release/libbreez_sdk_spark_bindings.so \
      $out/lib/libbreez_sdk_spark_bindings.so
    runHook postInstall
  '';

  meta = {
    description = "Rust library for the Breez SDK Spark bindings";
    homepage = "https://github.com/breez/spark-sdk";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.tensor5 ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
})
