{ stdenv, nixpkgs-review }:

<<<<<<< HEAD
# nixpkgs-update: no auto update
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
nixpkgs-review.override {
  withSandboxSupport = stdenv.hostPlatform.isLinux;
  withNom = true;
  withDelta = true;
  withGlow = true;
}
