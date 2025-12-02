{
  lib,
  stdenv,
  fetchFromGitHub,
  pnpm_10,
  nodejs,
  electron,
  makeDesktopItem,
  copyDesktopItems,
  imagemagick,
  makeWrapper,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gitify";
  version = "6.14.1";

  src = fetchFromGitHub {
    owner = "gitify-app";
    repo = "gitify";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nZoWqfocEg33C22CfVIkayUWkkZ29A8FcAEXx+tJGUU=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_10.configHook
    copyDesktopItems
    imagemagick
    makeWrapper
  ];

  pnpmDeps = pnpm_10.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 2;
    hash = "sha256-LnYwUXwGm/2yx7QrMcPu32oPtRJKnuqysecwwH25QIg=";
  };

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = 1;

  postPatch = ''
    substituteInPlace config/electron-builder.js \
      --replace-fail "'Adam Setch (5KD23H9729)'" "null" \
      --replace-fail "'scripts/afterSign.js'" "null"
  '';

  buildPhase = ''
    runHook preBuild

    # electronDist needs to be modifiable on Darwin
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    pnpm build
    pnpm exec electron-builder \
        --config config/electron-builder.js \
        --dir \
        -c.electronDist=electron-dist \
        -c.electronVersion="${electron.version}" \

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ${
      if stdenv.hostPlatform.isDarwin then
        ''
          mkdir -p $out/Applications
          cp -r dist/mac*/Gitify.app $out/Applications
          makeWrapper $out/Applications/Gitify.app/Contents/MacOS/gitify $out/bin/gitify
        ''
      else
        ''
          mkdir -p $out/share/gitify
          cp -r dist/*-unpacked/{locales,resources{,.pak}} $out/share/gitify

          mkdir -p $out/share/icons/hicolor/256x256/apps
          magick assets/images/app-icon.ico $out/share/icons/hicolor/256x256/apps/gitify.png

          makeWrapper ${lib.getExe electron} $out/bin/gitify \
              --add-flags $out/share/gitify/resources/app.asar \
              --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
              --inherit-argv0
        ''
    }

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "gitify";
      desktopName = "Gitify";
      exec = "gitify %U";
      icon = "gitify";
      comment = "GitHub notifications on your menu bar";
      categories = [ "Development" ];
      startupWMClass = "Gitify";
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://gitify.io/";
    changelog = "https://github.com/gitify-app/gitify/releases/tag/v${finalAttrs.version}";
    description = "GitHub notifications on your menu bar";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pineapplehunter ];
    platforms = lib.platforms.all;
  };
})
