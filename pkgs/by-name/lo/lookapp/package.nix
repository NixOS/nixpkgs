{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
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
  version = "0.6.13";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kunkka19xx";
    repo = "look";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rfSuwSRD1mHpvi8wP+xZNaE4bsc6btMRxAM4q/314FU=";
  };

  cargoRoot = "apps/linows/src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  cargoHash = "sha256-U58By3qm5hr35oZjOChOHgf7LcrJy5VEAAjKz+vWdmw=";

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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Keyboard-first, local-first desktop launcher";
    homepage = "https://github.com/kunkka19xx/look";
    changelog = "https://github.com/kunkka19xx/look/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "lookapp";

    maintainers = [
      lib.maintainers.Teamofeyy
      lib.maintainers.kunkka19xx
    ];
  };
})
