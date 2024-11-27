{ lib
, stdenv
, rustPlatform
, fetchFromGitLab
, pkg-config
, nettle
, openssl
, sqlite
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "sequoia-chameleon-gnupg";
  version = "0.11.2";

  src = fetchFromGitLab {
    owner = "sequoia-pgp";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-XoZA8X6lwziKFECJDPCSpqcFtJe5TsDGWvM+EgpBU3U=";
  };

  cargoHash = "sha256-xDQCAte+olmoMbchspNW/02NRkhwWxcgPkIXWBJsbIg=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    pkg-config
  ];

  buildInputs = [
    nettle
    openssl
    sqlite
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
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
