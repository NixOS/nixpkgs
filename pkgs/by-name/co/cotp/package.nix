{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  libxcb,
}:

rustPlatform.buildRustPackage rec {
  pname = "cotp";
  version = "1.9.7";

  src = fetchFromGitHub {
    owner = "replydev";
    repo = "cotp";
    rev = "v${version}";
    hash = "sha256-N3UPeEc3xPIRHt1lOwd8c7e61jZk3PPo3sC/7BQBosY=";
  };

  cargoHash = "sha256-3IJV7X3G12+ca723sDhOn4SN9CeqKPzGs59IQBYS5QY=";

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ libxcb ];

  meta = with lib; {
    homepage = "https://github.com/replydev/cotp";
    description = "Trustworthy, encrypted, command-line TOTP/HOTP authenticator app with import functionality";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ davsanchez ];
    mainProgram = "cotp";
  };
}
