{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

let
  rev = "035d6e9695016b79b0a237d00d97bd98c4396aff";
  rust-shed-hash = "sha256-O6ez+gQqFRtOEoYWn+HQm0/gXmi5BOvQy03Ck5dKL68=";
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "buck2-change-detector";
  version = "0-unstable-2026-03-11";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = "buck2-change-detector";
    inherit rev;
    hash = "sha256-oxybM/icApSfyhGqiIreqpdmnnaVDn7fQNAvxFK4Vb4=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "fbinit-0.2.0" = rust-shed-hash;
      "fbinit-tokio-0.1.2" = rust-shed-hash;
      "fbinit_macros-0.2.0" = rust-shed-hash;
      "sampling-0.1.0" = rust-shed-hash;
      "scuba-0.1.0" = rust-shed-hash;
      "scuba_sample-0.1.0" = rust-shed-hash;
      "scuba_sample_builder-0.1.0" = rust-shed-hash;
      "scuba_sample_client-0.1.0" = rust-shed-hash;
      "scuba_sample_derive-0.1.0" = rust-shed-hash;
    };
  };

  env.RUSTC_BOOTSTRAP = 1;

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  meta = {
    description = "Detect affected Buck2 targets from file changes";
    homepage = "https://github.com/facebookincubator/buck2-change-detector";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ jakewins ];
    mainProgram = "supertd";
    platforms = lib.platforms.unix;
  };
})
