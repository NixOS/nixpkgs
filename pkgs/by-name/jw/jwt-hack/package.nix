{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jwt-hack";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "hahwul";
    repo = "jwt-hack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kutt5VhMY/YIXBpVZTg/xAwa9d+J5ypfLi5aLakjfaY=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  OPENSSL_NO_VENDOR = 1;

  meta = {
    description = "JSON Web Token Hack Toolkit";
    homepage = "https://github.com/hahwul/jwt-hack";
    changelog = "https://github.com/hahwul/jwt-hack/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "jwt-hack";
  };
})
