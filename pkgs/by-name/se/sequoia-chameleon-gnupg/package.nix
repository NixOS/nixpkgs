{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitLab,
  pkg-config,
  nettle,
  openssl,
  sqlite,
}:

rustPlatform.buildRustPackage rec {
  pname = "sequoia-chameleon-gnupg";
  version = "0.13.1";

  src = fetchFromGitLab {
    owner = "sequoia-pgp";
    repo = "sequoia-chameleon-gnupg";
    rev = "v${version}";
    hash = "sha256-K9aeWrqJGPx2RymCXWNdNUTXXtO4NNm6Rd3jz+YxEi0=";
  };

  cargoHash = "sha256-d+Ew05pYpUepqsYLTcI3j2qcplXn2hDACyzXXDx6hNg=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    pkg-config
  ];

  buildInputs = [
    nettle
    openssl
    sqlite
  ];

  # gpgconf: error creating socket directory
  doCheck = false;

  meta = with lib; {
    description = "Sequoia's reimplementation of the GnuPG interface";
    homepage = "https://gitlab.com/sequoia-pgp/sequoia-chameleon-gnupg";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ nickcao ];
    mainProgram = "gpg-sq";
  };
}
