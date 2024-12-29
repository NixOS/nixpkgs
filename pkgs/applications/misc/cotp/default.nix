{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, AppKit
, libxcb
}:

rustPlatform.buildRustPackage rec {
  pname = "cotp";
  version = "1.7.3";

  src = fetchFromGitHub {
    owner = "replydev";
    repo = "cotp";
    rev = "v${version}";
    hash = "sha256-CBe/K06z4oqpiwHKwAkWdp+zwAV6Qzne6T/xSSIRz7Y=";
  };

  cargoHash = "sha256-OMQnmZacHNTGAyBoTLulvwXb6DELFag70m5C75FQ648=";

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
