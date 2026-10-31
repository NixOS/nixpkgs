{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  wrapGAppsHook4,
  gnome,
  gdk-pixbuf,
  webp-pixbuf-loader,
  gtk4,
  sqlite,
  gsettings-desktop-schemas,
  python3,
  curl,
  ripgrep,
  xdg-utils,
  makeDesktopItem,
  copyDesktopItems,
  desktop-file-utils,
  runCommand,
  # Optional tools the upstream test suite exercises. They are not part of the
  # runtime closure, so the features that call them stay optional.
  ffmpeg,
  git,
  gzip,
  poppler-utils,
  vips,
  zbar,
}:

let
  # gdk-pixbuf keeps PNG and JPEG in the library, but WebP needs the separate
  # loader package and a loaders cache that covers it.
  gdkPixbufLoaders = gnome._gdkPixbufCacheBuilder_DO_NOT_USE {
    extraLoaders = [ webp-pixbuf-loader ];
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "spotlight";
  version = "0.4.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "danny19862025";
    repo = "spotlight";
    rev = "8f47baa446b8abfb53e766b7f07bc7b49e7b874c";
    hash = "sha256-YehaJL9Rb58uEmGaTR8RUo+yrIEdLDVqARJoVVSm328=";
  };

  cargoHash = "sha256-BuWTx7ohs8cDYRFMY8yklAPjbE5j20ULbrtTaIz2vxg=";

  nativeBuildInputs = [
    copyDesktopItems
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gdk-pixbuf
    gsettings-desktop-schemas
    gtk4
    sqlite
    webp-pixbuf-loader
  ];

  nativeCheckInputs = [
    curl
    ffmpeg
    git
    gzip
    poppler-utils
    python3
    ripgrep
    vips
    zbar
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "spotlight";
      desktopName = "Spotlight";
      comment = "Search apps, files, clipboard, snippets, and commands";
      exec = "spotlight";
      icon = "spotlight";
      categories = [ "Utility" ];
      startupWMClass = "local.spotlight.Spotlight";
    })
  ];

  preCheck = ''
    export GDK_PIXBUF_MODULE_FILE=${gdkPixbufLoaders}
  '';

  postInstall = ''
    # Read by the gapps wrapper hook below, so it has to be set here.
    export GDK_PIXBUF_MODULE_FILE=${gdkPixbufLoaders}
    install -Dm644 assets/spotlight.svg \
      $out/share/icons/hicolor/scalable/apps/spotlight.svg
    install -Dm644 docs/community-plugins.toml \
      $out/lib/spotlight/community-plugins.toml
    for license in LICENSE assets/UNICODE-LICENSE.txt assets/QRCODEGEN-LICENSE.txt; do
      install -Dm644 "$license" "$out/share/licenses/spotlight/$(basename "$license")"
    done
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --set GSK_RENDERER cairo
      # The autostart entry has to start the wrapped process.
      --set SPOTLIGHT_EXECUTABLE $out/bin/spotlight
      --prefix PATH : ${
        lib.makeBinPath [
          curl
          python3
          ripgrep
          xdg-utils
        ]
      }
    )
  '';

  passthru.tests.smoke =
    runCommand "spotlight-smoke"
      {
        nativeBuildInputs = [ desktop-file-utils ];
      }
      ''
        test -x ${finalAttrs.finalPackage}/bin/spotlight
        desktop-file-validate ${finalAttrs.finalPackage}/share/applications/spotlight.desktop
        touch $out
      '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Keyboard-first native Linux productivity launcher";
    homepage = "https://github.com/danny19862025/spotlight";
    changelog = "https://github.com/danny19862025/spotlight/commits/8f47baa446b8abfb53e766b7f07bc7b49e7b874c";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "spotlight";
    maintainers = [
      lib.maintainers.danny19862025
    ];
  };
})
