{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_10,
  nodejs_22,
  wails,
  pkg-config,
  sysctl,
  gtk3,
  webkitgtk_4_1,
  glib-networking,
  gsettings-desktop-schemas,
  wrapGAppsHook3,
  copyDesktopItems,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "pelton";
  version = "2026.4.1";

  src = fetchFromGitHub {
    owner = "peltonapp";
    repo = "Pelton";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Lv5CHfKSA7GpVFZ56BNvxoFMTsZmlFk+RxzVl3asSeA=";
  };

  proxyVendor = true;
  vendorHash = "sha256-15fh1ZthbMVdmpl6EimKMrLUH0tLeu5hRHBTTPg+I8k=";

  env.pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    sourceRoot = "${finalAttrs.src.name}/frontend";
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = "sha256-cC2VIAels6+/3xA+V3ueFyoatLOUZKwxUCoOheM6rtA=";
  };
  env.pnpmRoot = "frontend";

  postPatch = ''
    substituteInPlace wails.json \
      --replace-fail '"productVersion": "0.0.0"' '"productVersion": "${finalAttrs.version}"'
  '';

  nativeBuildInputs = [
    pkg-config
    pnpmConfigHook
    pnpm_10
    nodejs_22
    wails
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wrapGAppsHook3
    copyDesktopItems
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin sysctl;

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    gtk3
    webkitgtk_4_1
    glib-networking
    gsettings-desktop-schemas
  ];

  buildPhase = ''
    runHook preBuild
    wails build -m -trimpath -skipbindings \
      ${lib.optionalString stdenv.hostPlatform.isLinux "-tags webkit2_41"} \
      -ldflags "-X main.version=v${finalAttrs.version}" -o pelton
    runHook postBuild
  '';

  # The upstream suite includes integration tests requiring network access.
  doCheck = false;

  desktopItems = [ "build/linux/pelton.desktop" ];

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm755 build/bin/pelton $out/bin/pelton
    install -Dm644 build/linux/pelton.metainfo.xml $out/share/metainfo/pelton.metainfo.xml
    install -Dm644 build/icons/pelton-512.png $out/share/icons/hicolor/512x512/apps/pelton.png
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications $out/bin
    cp -R build/bin/Pelton.app $out/Applications/
    cp DISCLAIMER.md $out/Applications/Pelton.app/Contents/Resources/
    ln -s $out/Applications/Pelton.app/Contents/MacOS/pelton $out/bin/pelton
  ''
  + ''
    runHook postInstall
  '';

  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Privacy-focused desktop email client";
    homepage = "https://pelton.app/";
    changelog = "https://github.com/peltonapp/Pelton/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    mainProgram = "pelton";
    maintainers = with lib.maintainers; [ agarmu ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
