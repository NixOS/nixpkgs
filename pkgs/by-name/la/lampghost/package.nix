{
  lib,
  stdenv,
  nodejs,
  gtk3,
  webkitgtk_4_1,
  pkg-config,
  libsoup_3,
  glib-networking,
  gsettings-desktop-schemas,
  xorg,
  at-spi2-core,
  wails,
  buildGoModule,
  fetchFromGitHub,
  fetchNpmDeps,
  npmHooks,
  copyDesktopItems,
  makeDesktopItem,
  autoPatchelfHook,
  wrapGAppsHook3,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "lampghost";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "Catizard";
    repo = "lampghost";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ok4dP4I1UJrJNcc+iMt58r4xpV5siH5b1aEcgVZ/beY=";
  };

  vendorHash = "sha256-b2nWUsZjdNR2lmY9PPEhba/NsOn1K4nLDZhv71zxAK8=";

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
    copyDesktopItems
    gsettings-desktop-schemas
    # Hooks
    autoPatchelfHook
    npmHooks.npmConfigHook
    wrapGAppsHook3
  ];

  buildInputs = [
    webkitgtk_4_1
    gtk3
    libsoup_3
    glib-networking
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    # Core X11 libraries
    xorg.libX11 # X11 core protocol client library
    xorg.libXcursor # X11 cursor management library
    xorg.libXrandr # X11 RandR extension library for screen configuration
    xorg.libXinerama # X11 Xinerama extension for multi-monitor support
    xorg.libXi # X11 Input extension library for input devices
    xorg.libXxf86vm # X11 video mode extension library

    # X11 clipboard and graphics extensions
    xorg.libXfixes # X11 fixes extension for clipboard and window regions
    xorg.libXext # X11 basic extensions library
    xorg.libXcomposite # X11 composite extension for window composition
    xorg.libXdamage # X11 damage extension for window damage tracking
    xorg.libXrender # X11 rendering extension for 2D graphics

    # Additional Linux dependencies
    xorg.xvfb # X Virtual Framebuffer for headless testing
    xorg.xorgserver # X11 server utilities
    at-spi2-core # AT-SPI core for accessibility
  ];

  buildPhase = ''
    runHook preBuild

    wails build -m -trimpath -devtools -tags webkit2_41 -o ${finalAttrs.pname}

    runHook postBuild
  '';

  desktopItems = [
    (makeDesktopItem {
      name = finalAttrs.pname;
      exec = finalAttrs.pname;
      desktopName = "LampGhost";
      comment = "Offline & Cross-platform beatoraja lamp viewer and more";
      categories = [ "Game" ];
      startupNotify = true;
      keywords = [ "beatoraja" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    install -Dm0755 build/bin/${finalAttrs.pname} $out/bin/${finalAttrs.pname}

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
    mainProgram = finalAttrs.pname;
    maintainers = with lib.maintainers; [ MiyakoMeow ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
