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
    xorg.libX11
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXinerama
    xorg.libXi
    xorg.libXxf86vm
    xorg.libXfixes
    xorg.libXext
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXrender
    xorg.xvfb
    xorg.xorgserver
    at-spi2-core
  ];

  buildPhase = ''
    runHook preBuild

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
