{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "jwt-hack";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "hahwul";
    repo = "jwt-hack";
    tag = "v${version}";
    hash = "sha256-uJur/ABoAaQT3BBO2yprK/0/bQPT138Yg9IbztZ6w2w=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  meta = {
    description = "JSON Web Token Hack Toolkit";
    homepage = "https://github.com/hahwul/jwt-hack";
    changelog = "https://github.com/hahwul/jwt-hack/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "jwt-hack";
  };
}
