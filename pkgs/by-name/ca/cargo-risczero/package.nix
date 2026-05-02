{
  lib,
  fetchCrate,
  fetchurl,
  rustPlatform,
  pkg-config,
  openssl,
  nix-update-script,
}:
let
  # That is from cargoDeps/risc0-circuit-recursion/build.rs
  src-recursion-hash = "744b999f0a35b3c86753311c7efb2a0054be21727095cf105af6ee7d3f4d8849";
  src-recursion = fetchurl {
    name = "cargo-risczero-recursion-source";
    url = "https://risc0-artifacts.s3.us-west-2.amazonaws.com/zkr/${src-recursion-hash}.zip";
    outputHash = src-recursion-hash; # This hash should be the same as src-recuresion-hash
    outputHashAlgo = "sha256";
  };
in

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-risczero";
  version = "3.0.5";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-1tuY+XoZpilak9gc5vDnRDEB1SK+itBWoGNxwefT6xo=";
  };

  env = {
    RECURSION_SRC_PATH = src-recursion;
  };

  cargoHash = "sha256-ayKQvhjYawPEl9ryVmDx4J93/EGPSeKds0mOnkRI2Fo=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cargo extension to help create, manage, and test RISC Zero projects";
    mainProgram = "cargo-risczero";
    homepage = "https://risczero.com";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ cameronfyfe ];
  };
})
