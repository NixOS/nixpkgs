{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  libxcb,
}:

rustPlatform.buildRustPackage rec {
  pname = "cotp";
  version = "1.9.6";

  src = fetchFromGitHub {
    owner = "replydev";
    repo = "cotp";
    rev = "v${version}";
    hash = "sha256-bbmxnzCUvhZ7rjaqbFCB+Qqx3EfY/W8OKhMNlt6KQ64=";
  };

  cargoHash = "sha256-pWgHwqU/xbD5aA2ZCuI7PaImmdojHATgZ+SVSwjnqbk=";

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ libxcb ];

  meta = with lib; {
    homepage = "https://github.com/replydev/cotp";
    description = "Trustworthy, encrypted, command-line TOTP/HOTP authenticator app with import functionality";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ davsanchez ];
    mainProgram = "cotp";
  };
}
