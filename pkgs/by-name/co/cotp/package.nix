{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  libxcb,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cotp";
  version = "1.9.7";

  src = fetchFromGitHub {
    owner = "replydev";
    repo = "cotp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-N3UPeEc3xPIRHt1lOwd8c7e61jZk3PPo3sC/7BQBosY=";
  };

  cargoHash = "sha256-3IJV7X3G12+ca723sDhOn4SN9CeqKPzGs59IQBYS5QY=";

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ libxcb ];

  meta = {
    homepage = "https://github.com/replydev/cotp";
    description = "Trustworthy, encrypted, command-line TOTP/HOTP authenticator app with import functionality";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ davsanchez ];
    mainProgram = "cotp";
  };
})
