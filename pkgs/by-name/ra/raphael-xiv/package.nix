{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  glib,
  gdk-pixbuf,
  cairo,
  gtk3,
  libsoup_3,
  webkitgtk_4_1,
  xdotool,
  libx11,
  copyDesktopItems,
  makeDesktopItem,
  wrapGAppsHook3,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "raphael-xiv";
  version = "0.29.3";

  src = fetchFromGitHub {
    owner = "KonaeAkira";
    repo = "raphael-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Xo/2aYuOhyPGOOlTnfSq0VrynyTOg6JtT36e44R1J8U=";
  };

  cargoHash = "sha256-5U59PuVnJZgDokVJB9WNhImCCmXaj3ca8jB+m4v2SFo=";

  nativeBuildInputs = [
    copyDesktopItems
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gdk-pixbuf
    cairo
    gtk3
    libsoup_3
    webkitgtk_4_1
    openssl
    xdotool
    libx11
  ];

  cargoBuildFlags = [
    "--package"
    "raphael-gui"
    "--package"
    "raphael-cli"
  ];

  preInstall = ''
    mkdir -p "$out/share/icons/hicolor/64x64/apps"
    cp assets/favicon-64x64.png "$out/share/icons/hicolor/64x64/apps/raphael-xiv.png"
  '';

  __structuredAttrs = true;

  desktopItems = [
    (makeDesktopItem {
      name = finalAttrs.pname;
      exec = "raphael-gui";
      icon = "raphael-xiv";
      desktopName = "Raphael XIV";
      comment = finalAttrs.meta.description;
    })
  ];

  meta = {
    description = "Crafting macro solver for Final Fantasy XIV";
    homepage = "https://github.com/KonaeAkira/raphael-rs";
    changelog = "https://github.com/KonaeAkira/raphael-rs/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hekazu ];
    mainProgram = "raphael-gui";
    platforms = lib.platforms.linux;
  };
})
