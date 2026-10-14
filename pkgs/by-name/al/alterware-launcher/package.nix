{
  lib,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "alterware-launcher";
  version = "0.11.6";

  src = fetchFromGitHub {
    owner = "alterware";
    repo = "alterware-launcher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cJ5JRFXmy3/OKgEX/A5KOkNV3TiRXpZlgEdWJJTghhE=";
  };

  cargoHash = "sha256-O1Amsc0DwKwe1rgElQSWME9b92WsOin3urvme7EqJYg=";

  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];

  env.OPENSSL_NO_VENDOR = true;

  meta = {
    description = "Official launcher for AlterWare Call of Duty mods";
    longDescription = "Our clients are designed to restore missing features that have been removed by the developers, as well as enhance the capabilities of the games";
    homepage = "https://alterware.dev";
    downloadPage = "https://github.com/alterware/alterware-launcher";
    changelog = "https://github.com/alterware/alterware-launcher/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ andrewfield ];
    mainProgram = "alterware-launcher";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
