{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  pango,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "i3bar-river";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "MaxVerevkin";
    repo = "i3bar-river";
    rev = "v${finalAttrs.version}";
    hash = "sha256-0ux0woVp9HVCJf/oND2AKHj30eNC/w1WDnlPafLTgxM=";
  };

  cargoHash = "sha256-dwOinrHvk0MRKlbn62MEfmcyXNf+ZfYzVNtv7teRsV4=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ pango ];

  meta = {
    description = "Port of i3bar for river";
    homepage = "https://github.com/MaxVerevkin/i3bar-river";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ nicegamer7 ];
    mainProgram = "i3bar-river";
    platforms = lib.platforms.linux;
  };
})
