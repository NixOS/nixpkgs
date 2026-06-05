{ stdenv, nixpkgs-review }:

# nixpkgs-update: no auto update
nixpkgs-review.override {
  withSandboxSupport = stdenv.hostPlatform.isLinux;
  withNom = true;
  withDelta = true;
  withGlow = true;
}
