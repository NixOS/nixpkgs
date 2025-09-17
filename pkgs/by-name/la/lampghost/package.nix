{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchNpmDeps,
  npmHooks,
  nodejs,
  wails,
  webkitgtk_4_1,
  pkg-config,
  copyDesktopItems,
  makeDesktopItem,
  autoPatchelfHook,
  nix-update-script,
  xorg,
  stdenv,
  gtk4,
  libsoup_3,
  gtk3,
  glib-networking,
  gsettings-desktop-schemas,
}:
buildGoModule (finalAttrs: {
  pname = "lampghost";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "Catizard";
    repo = "lampghost";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PM6+QG9pBBDqaK60i4IXZ56UgXJ+DoOZqKJ/+HjdMjo=";
  };

  vendorHash = "sha256-WU9sjoV1cfzt+Ol0pWwWeqwxGXnGsuz0BSI2GcCmh9Q=";

  env = {
    CGO_ENABLED = 1;
    npmDeps = fetchNpmDeps {
      src = "${finalAttrs.src}/frontend";
      hash = "sha256-YYF6RfA3uE65QdwuJMV+NSvGYtmZRxwrVbQtijNyHRE=";
    };
    npmRoot = "frontend";
  };

  nativeBuildInputs = [
    wails
    pkg-config
    autoPatchelfHook
    nodejs
    npmHooks.npmConfigHook
    copyDesktopItems
    # Ensure pkg-config in strict deps setups finds webkit2gtk-4.1.pc
    webkitgtk_4_1
    gtk4
    libsoup_3
    glib-networking
    gsettings-desktop-schemas
  ];

  buildInputs = [
    webkitgtk_4_1
    gtk4
    libsoup_3
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    xorg.libX11
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXinerama
    xorg.libXi
    xorg.libXxf86vm
  ];

  buildPhase = ''
    runHook preBuild

    export PKG_CONFIG_LIBDIR="${
      lib.makeSearchPath "lib/pkgconfig" [
        webkitgtk_4_1.dev
        gtk4.dev
        libsoup_3.dev
      ]
    }:${
      lib.makeSearchPath "share/pkgconfig" [
        webkitgtk_4_1.dev
        gtk4.dev
        libsoup_3.dev
      ]
    }"
    export PKG_CONFIG_PATH="$PKG_CONFIG_LIBDIR:$PKG_CONFIG_PATH"

    export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
    export GIO_MODULE_DIR="${glib-networking}/lib/gio/modules/"

    wails build -m -trimpath -devtools -tags webkit2_41 -o lampghost

    runHook postBuild
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "lampghost";
      exec = "lampghost";
      desktopName = "LampGhost";
      comment = "Offline & Cross-platform beatoraja lamp viewer and more";
      categories = [ "Game" ];
      startupNotify = true;
      keywords = [ "beatoraja" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    install -Dm0755 build/bin/lampghost $out/bin/lampghost

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Offline & Cross-platform beatoraja lamp viewer and more";
    homepage = "https://github.com/Catizard/lampghost";
    changelog = "https://github.com/Catizard/lampghost/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "lampghost";
    maintainers = with lib.maintainers; [ MiyakoMeow ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
