{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "rlci";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "orsinium-labs";
    repo = "rlci";
    rev = version;
    hash = "sha256-+Hd1Ymm2LKnHUKoUlfN6D6pwebxgwJQHgqwMHXXtP6Y=";
  };

  cargoHash = "sha256-7Q6WSEiVLzRsyHNECbPhWN9prrN0A/nSJDtZWi09zzg=";

  meta = with lib; {
    description = "Lambda calculus interpreter";
    mainProgram = "rlci";
    homepage = "https://github.com/orsinium-labs/rlci";
    changelog = "https://github.com/orsinium-labs/rlci/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
