{
  lib,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "alterware-launcher";
  version = "0.11.5";

  src = fetchFromGitHub {
    owner = "alterware";
    repo = "alterware-launcher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-I2HlLi8f0+p1Gk7QzwNxOAOix0dxGKMmNkcXilQANzo=";
  };

  cargoHash = "sha256-M0Y59+p0SiDiE0MM165l/5HAYc2A00S9TDcYfzdAuAw=";

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
