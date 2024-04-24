{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, AppKit
, libxcb
}:

rustPlatform.buildRustPackage rec {
  pname = "cotp";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "replydev";
    repo = "cotp";
    rev = "v${version}";
    hash = "sha256-Zs/RUpyu8GG4koprC+8aSzpPUSLc19p/XinY5fR5Z4A=";
  };

  cargoHash = "sha256-jYKu1sAzPUfv8gQj3V4zxarRj3XUhyD/5n1WqMuLF/g=";

  buildInputs = lib.optionals stdenv.isLinux [ libxcb ]
    ++ lib.optionals stdenv.isDarwin [ AppKit ];

  meta = with lib; {
    homepage = "https://github.com/replydev/cotp";
    description = "Trustworthy, encrypted, command-line TOTP/HOTP authenticator app with import functionality";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ davsanchez ];
    mainProgram = "cotp";
  };
}
