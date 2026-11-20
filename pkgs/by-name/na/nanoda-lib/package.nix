{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nanoda-lib";
  version = "0.4.32";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ammkrn";
    repo = "nanoda_lib";
    rev = "0da9f98feadd3a0a2ef4b3dbcf52a298a6fef929";
    hash = "sha256-Gr7KkmIwOJHBsQ9s+fU5lnZAOeDHxnyxsOGYKjuwHDs=";
  };

  cargoHash = "sha256-op1SXq5u99nUPwX6PLoE8ovvLeTrvY4AgtGH70lsMI0=";

  meta = {
    description = "Library implementing type inference/checking functionality based on the Lean theorem prover";
    homepage = "https://github.com/ammkrn/nanoda_lib";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "nanoda_bin";
  };
})
