{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  libxcb,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cotp";
  version = "1.9.9";

  src = fetchFromGitHub {
    owner = "replydev";
    repo = "cotp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-P7QeT3q//nmv11i0pELfTCC/wi9jHqbYClqSvvkvqwA=";
  };

  cargoHash = "sha256-PhUHFLl0yr/eWy2A+zp+gTNlW+zbruCqQLkHA6Ivf04=";

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ libxcb ];

  meta = {
    homepage = "https://github.com/replydev/cotp";
    description = "Trustworthy, encrypted, command-line TOTP/HOTP authenticator app with import functionality";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ davsanchez ];
    mainProgram = "cotp";
  };
})
