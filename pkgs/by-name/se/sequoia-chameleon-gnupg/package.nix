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
  version = "0.13.0";

  src = fetchFromGitLab {
    owner = "sequoia-pgp";
    repo = "sequoia-chameleon-gnupg";
    rev = "v${version}";
    hash = "sha256-K8IFuc+ykXKnx5NiWeLzCkVpgvi4apbJl6AKrBvVIaA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-lFeE/orMcb5an2MFlh94RaCh0fVEP8EP97CYNW56O4o=";

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
