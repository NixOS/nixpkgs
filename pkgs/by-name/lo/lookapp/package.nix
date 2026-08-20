{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook3,
  webkitgtk_4_1,
  gtk3,
  libsoup_3,
  glib,
  cairo,
  pango,
  gdk-pixbuf,
  harfbuzz,
  alsa-lib,
  dbus,
  openssl,
  libappindicator,
  xdg-utils,
  fontconfig,
  curl,
  procps,
  copyDesktopItems,
  makeDesktopItem,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lookapp";
  version = "0.6.11";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kunkka19xx";
    repo = "look";
    tag = "v${version}";
    hash = "sha256-m8/FhPXmJvRDq92g5mE1k6ABkFigka2hzkJHV0ZH7lA=";
  };

  cargoRoot = "apps/linows/src-tauri";
  buildAndTestSubdir = cargoRoot;

  cargoHash = "sha256-Z0PyN/xkqVfXJUX8VCU7rwcr7B74K/kLx5XI3kfkoaM=";

  nativeBuildInputs = [
    copyDesktopItems
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    webkitgtk_4_1
    gtk3
    libsoup_3
    glib
    cairo
    pango
    gdk-pixbuf
    harfbuzz
    alsa-lib
    dbus
    openssl
    libappindicator
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "lookapp";
      desktopName = "Look";
      comment = "Keyboard-first desktop launcher";
      exec = "lookapp";
      icon = "look";
      categories = [ "Utility" ];
      startupWMClass = "Look";
    })
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : ${
        lib.makeBinPath [
          xdg-utils
          fontconfig
          curl
          procps
          glib
        ]
      }
    )
  '';

  postInstall = ''
    for size in 32 128 256; do
      icon="$src/apps/linows/src-tauri/icons/''${size}x''${size}.png"
      if [ -f "$icon" ]; then
        mkdir -p $out/share/icons/hicolor/''${size}x''${size}/apps
        cp "$icon" \
          "$out/share/icons/hicolor/''${size}x''${size}/apps/look.png"
      fi
    done
  '';

  meta = {
    description = "Keyboard-first, local-first desktop launcher";
    homepage = "https://github.com/kunkka19xx/look";
    changelog = "https://github.com/kunkka19xx/look/releases/tag/v${version}";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "lookapp";

    maintainers = [
      lib.maintainers.Teamofeyy
      lib.maintainers.kunkka19xx
    ];
  };
})