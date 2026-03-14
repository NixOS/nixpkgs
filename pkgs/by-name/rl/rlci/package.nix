{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rlci";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "orsinium-labs";
    repo = "rlci";
    rev = finalAttrs.version;
    hash = "sha256-+Hd1Ymm2LKnHUKoUlfN6D6pwebxgwJQHgqwMHXXtP6Y=";
  };

  cargoHash = "sha256-ckHwg7jEXZV0hjZFeR5dbqrt9APcyRV95LikwCFw/fM=";

  meta = {
    description = "Lambda calculus interpreter";
    mainProgram = "rlci";
    homepage = "https://github.com/orsinium-labs/rlci";
    changelog = "https://github.com/orsinium-labs/rlci/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
