{
  lib,
  stdenv,
  fetchCrate,
  fetchurl,
  rustPlatform,
  pkg-config,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-risczero";
  version = "1.1.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-YZ3yhj1VLxl3Fg/yWhqrZXxIQ7oK6Gdo0NU39oDvoo8=";
  };

  src-recursion-hash = "28e4eeff7a8f73d27408d99a1e3e8842c79a5f4353e5117ec0b7ffaa7c193612"; # That is from cargoDeps/risc0-circuit-recursion/build.rs

  src-recursion = fetchurl {
    url = "https://risc0-artifacts.s3.us-west-2.amazonaws.com/zkr/${src-recursion-hash}.zip";
    hash = "sha256-KOTu/3qPc9J0CNmaHj6IQseaX0NT5RF+wLf/qnwZNhI="; # This hash should be the same as src-recuresion-hash
  };

  env = {
    RECURSION_SRC_PATH = src-recursion;
  };

  cargoHash = "sha256-r2bs1MT2jBK4ATUKyRGLEAFCHNaGnnQ4jbQOKbQbldY=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  # The tests require network access which is not available in sandboxed Nix builds.
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cargo extension to help create, manage, and test RISC Zero projects";
    mainProgram = "cargo-risczero";
    homepage = "https://risczero.com";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ cameronfyfe ];
  };
}
