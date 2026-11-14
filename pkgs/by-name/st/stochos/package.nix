{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wayland,
  withWayland ? true,
  withX11 ? true,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stochos";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "museslabs";
    repo = "stochos";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6Z7oIhlAXrRy6lpXqcTlYqWxlHuypVEXK+yho2ziQEU=";
  };

  cargoHash = "sha256-Rx8U1NPC2jERzI2nBfZhUxzUFYaaVc+PcbC6t3OMXQo=";

  buildNoDefaultFeatures = true;
  buildFeatures = lib.optional withWayland "wayland" ++ lib.optional withX11 "x11";

  nativeBuildInputs = lib.optional withWayland pkg-config;
  buildInputs = lib.optional withWayland wayland;

  meta = {
    description = "Keyboard-driven mouse control overlay for Wayland and X11";
    homepage = "https://github.com/museslabs/stochos";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ mrmebelman ];
    mainProgram = "stochos";
    platforms = lib.platforms.linux;
  };
})
