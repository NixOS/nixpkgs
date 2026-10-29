{
  stdenv,
  cargo,
  rustc,
  fetchFromGitHub,
  libadwaita,
  rustPlatform,
  pkg-config,
  lib,
  wrapGAppsHook4,
  meson,
  ninja,
  desktop-file-utils,
  blueprint-compiler,
  glib-networking,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "geopard";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "ranfdev";
    repo = "geopard";
    rev = "v${finalAttrs.version}";
    hash = "sha256-wOkzylRfFJsdu9KC4TvF/qYkGf8OZVd1tRre5TbNOX4=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-g7pHEBrR/tdKP+kuYJ44Py7kaAx0tXcMkC4UdsfSfDQ=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    blueprint-compiler
    desktop-file-utils
    cargo
    rustc
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    libadwaita
    glib-networking
  ];

  meta = {
    homepage = "https://github.com/ranfdev/Geopard";
    description = "Colorful, adaptive gemini browser";
    maintainers = with lib.maintainers; [
      jfvillablanca
      aleksana
    ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "geopard";
  };
})
