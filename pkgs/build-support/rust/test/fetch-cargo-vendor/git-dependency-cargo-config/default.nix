{ rustPlatform }:
rustPlatform.fetchCargoVendor {
  name = "git-dependency-cargo-config";
  src = ../../import-cargo-lock/git-dependency-cargo-config;
  hash = "sha256-rUQQ4Xrk+rW5Vgm7GK8xrK9zcwazsmBO6Q6qTCUniWc=";
}
