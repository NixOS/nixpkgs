{ stdenv, nixpkgs-review }:

nixpkgs-review.override {
  withSandboxSupport = stdenv.hostPlatform.isLinux;
  withNom = true;
  withDelta = true;
  withGlow = true;
}
