# with import <nixpkgs> {};
{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  protobuf,
  jdk,
  llvmPackages,
}:
rustPlatform.buildRustPackage rec {
  pname = "ballista";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = pname;
    rev = version;
    hash = "sha256-5mAU9EuQ4sIBLW3DAdPAYc0BEqL/pevaQwjVE0sfEfw=";
  };

  cargoHash = "sha256-/glrPWSsMXtnfC6NNzL7DgWrc9AKDnpYUFIoDXUUoWw=";

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  nativeBuildInputs = [
    protobuf
    jdk
  ];

  JAVA_HOME = "${jdk}";
  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  doCheck = false;

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  buildFeatures = [
    "ballista-executor"
    "ballista-scheduler"
    "s3"
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp -R target/x86_64-unknown-linux-gnu/release/ballista-executor $out/bin
    cp -R target/x86_64-unknown-linux-gnu/release/ballista-cli $out/bin
    cp -R target/x86_64-unknown-linux-gnu/release/ballista-scheduler $out/bin
    runHook postInstall
  '';

  meta = {
    description = "A distributed compute platform primarily implemented in Rust, largely inspired by Spark, and powered by Apache Arrow.";
    longDescription = ''
      Adds ballista-scheduler, ballista-executor, and ballista-cli.
    '';
    homepage = "https://github.com/apache/arrow-ballista";
    license = lib.licenses.asl20;
    maintainers = ["jhartma"];
    platforms = lib.platforms.all;
  };
}
