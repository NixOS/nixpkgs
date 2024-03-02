{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, AppKit
, libxcb
}:

rustPlatform.buildRustPackage rec {
  pname = "cotp";
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "replydev";
    repo = "cotp";
    rev = "v${version}";
    hash = "sha256-q0SI/y4pSNoU+4aQzpkUNioqrxmLxiA2GD1pmyLUISw=";
  };

  cargoHash = "sha256-pwhihmrFzb7y4ztXnzJVeMbo5VBoyjJTEDh5ogECLrA=";

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
