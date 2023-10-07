{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, AppKit
, libxcb
}:

rustPlatform.buildRustPackage rec {
  pname = "cotp";
  version = "1.2.5";

  src = fetchFromGitHub {
    owner = "replydev";
    repo = "cotp";
    rev = "v${version}";
    hash = "sha256-c2QjFDJmRLlXU1ZMOjb0BhIRgqubCTRyncc2KUKOhsg=";
  };

  cargoHash = "sha256-NnxgNk/C1DmEmPb2AcocsPsp2ngdyjbMP71M+fNL1qA=";

  buildInputs = lib.optionals stdenv.isLinux [ libxcb ]
    ++ lib.optionals stdenv.isDarwin [ AppKit ];

  meta = with lib; {
    homepage = "https://github.com/replydev/cotp";
    description = "Trustworthy, encrypted, command-line TOTP/HOTP authenticator app with import functionality";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ davsanchez ];
  };
}
