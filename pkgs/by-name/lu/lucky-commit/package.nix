{
  lib,
  rustPlatform,
  fetchFromGitHub,
  withOpenCL ? true,
  stdenv,
  ocl-icd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lucky-commit";
  version = "2.2.5";

  src = fetchFromGitHub {
    owner = "not-an-aardvark";
    repo = "lucky-commit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pghc2lTI81/z1bPJ6P2bFPyZkM8pko0V7lqv9rUUxWM=";
  };

  cargoHash = "sha256-zuWPkaYltxOOLaR6NTVkf1WbKzUQByml45jNL+e5UJ0=";

  buildInputs = lib.optional (withOpenCL && (!stdenv.hostPlatform.isDarwin)) ocl-icd;

  buildNoDefaultFeatures = !withOpenCL;

  # disable tests that require gpu
  checkNoDefaultFeatures = true;

  meta = {
    description = "Change the start of your git commit hashes to whatever you want";
    homepage = "https://github.com/not-an-aardvark/lucky-commit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ iamanaws ];
    mainProgram = "lucky_commit";
  };
})
