{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, AppKit
, libxcb
}:

rustPlatform.buildRustPackage rec {
  pname = "cotp";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "replydev";
    repo = "cotp";
    rev = "v${version}";
    hash = "sha256-Of4stKrk3zQX2gxXaM9YrZf1SVjzIVUU+7JraKHk180=";
  };

  cargoHash = "sha256-DLq8w65UlfAdPsJ96mNZ+dJtm/VMPzlIYqsEJtkLKzI=";

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
