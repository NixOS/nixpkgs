{
  lib,
  rustPlatform,
  fetchFromGitHub,
  withOpenCL ? true,
  stdenv,
  ocl-icd,
}:

<<<<<<< HEAD
rustPlatform.buildRustPackage (finalAttrs: {
=======
rustPlatform.buildRustPackage rec {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "lucky-commit";
  version = "2.2.5";

  src = fetchFromGitHub {
    owner = "not-an-aardvark";
    repo = "lucky-commit";
<<<<<<< HEAD
    tag = "v${finalAttrs.version}";
    hash = "sha256-pghc2lTI81/z1bPJ6P2bFPyZkM8pko0V7lqv9rUUxWM=";
=======
    rev = "v${version}";
    sha256 = "sha256-pghc2lTI81/z1bPJ6P2bFPyZkM8pko0V7lqv9rUUxWM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  cargoHash = "sha256-zuWPkaYltxOOLaR6NTVkf1WbKzUQByml45jNL+e5UJ0=";

  buildInputs = lib.optional (withOpenCL && (!stdenv.hostPlatform.isDarwin)) ocl-icd;

  buildNoDefaultFeatures = !withOpenCL;

  # disable tests that require gpu
  checkNoDefaultFeatures = true;

<<<<<<< HEAD
  meta = {
    description = "Change the start of your git commit hashes to whatever you want";
    homepage = "https://github.com/not-an-aardvark/lucky-commit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ iamanaws ];
    mainProgram = "lucky_commit";
  };
})
=======
  meta = with lib; {
    description = "Change the start of your git commit hashes to whatever you want";
    homepage = "https://github.com/not-an-aardvark/lucky-commit";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "lucky_commit";
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
