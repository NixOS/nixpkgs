{ rustPlatform }:
rustPlatform.importCargoLock {
  lockFile = ./Cargo.lock;
  outputHashes = {
    # Bootloader's .cargo/config.toml enables bindeps, which are required to parse its manifest.
    "bootloader-0.11.17" = "sha256-mLm5M1HLipN1EzS1zbDgMxMOqNySivGsK8+i0uOmoFM=";
  };
}
