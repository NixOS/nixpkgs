{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  AppKit,
  libxcb,
}:

rustPlatform.buildRustPackage rec {
  pname = "cotp";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "replydev";
    repo = "cotp";
    rev = "v${version}";
    hash = "sha256-Qr4pHtTQfJjRiFI4vZAynRWyJWYqWHYhZH4Mgd6OgR8=";
  };

  cargoHash = "sha256-U/kVN8oaNuZ9CdLkAQWK3H5kZv5qZgzWQwi8pHMVPcM=";

  buildInputs = lib.optionals stdenv.isLinux [ libxcb ] ++ lib.optionals stdenv.isDarwin [ AppKit ];

  meta = with lib; {
    homepage = "https://github.com/replydev/cotp";
    description = "Trustworthy, encrypted, command-line TOTP/HOTP authenticator app with import functionality";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ davsanchez ];
    mainProgram = "cotp";
  };
}
