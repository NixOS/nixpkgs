{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  libxcb,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cotp";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "replydev";
    repo = "cotp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Wtrf2u5OG8PvpKkoVCIr7c/BeDjQGTcyATKEmxIdyCg=";
  };

  cargoHash = "sha256-CePwZjXhdDN5HASP2q68cG4J5iKEzk3zPQuop8jMls8=";

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ libxcb ];

  meta = {
    homepage = "https://github.com/replydev/cotp";
    description = "Trustworthy, encrypted, command-line TOTP/HOTP authenticator app with import functionality";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ davsanchez ];
    mainProgram = "cotp";
  };
})
