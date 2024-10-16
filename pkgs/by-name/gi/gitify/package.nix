{
  lib,
  stdenv,
  fetchFromGitHub,
  pnpm,
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
  version = "5.13.1";

  src = fetchFromGitHub {
    owner = "gitify-app";
    repo = "gitify";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-j67+T+2hHtzXAcbOnh3eihOYq0Fp6XxBV2Dxw/hsncg=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm.configHook
    copyDesktopItems
    imagemagick
    makeWrapper
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-oxx/z3dSnOwEhINU9nRIlw1kv6XvJnSFGKykW0ZxzwI=";
  };

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = 1;

  buildPhase = ''
    runHook preBuild

    # electronDist needs to be modifiable on Darwin
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    pnpm build
    pnpm exec electron-builder \
        --dir \
        -c.electronDist=electron-dist \
        -c.electronVersion="${electron.version}" \

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ${
      if stdenv.isDarwin then
        ''
          mkdir -p $out/Applications
          cp -r dist/mac*/Gitify.app $out/Applications
          makeWrapper $out/Applications/Gitify.app/Contents/MacOS/gitify $out/bin/gitify
        ''
      else
        ''
          mkdir -p $out/share/gitify
          cp -r dist/*-unpacked/{locales,resources{,.pak}} $out/share/gitify

          for size in 16 32 48 64 128 256 512 1024; do
            mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
            magick assets/images/app-icon.ico -resize "$size"x"$size" $out/share/icons/hicolor/"$size"x"$size"/apps/gitify.png
          done

          makeWrapper ${lib.getExe electron} $out/bin/gitify \
              --add-flags $out/share/gitify/resources/app.asar \
              --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
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
      comment = "GitHub Notifications on your menu bar.";
      categories = [ "Development" ];
      startupWMClass = "Gitify";
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://www.gitify.io/";
    changelog = "https://github.com/gitify-app/gitify/releases/tag/v${finalAttrs.version}";
    description = "GitHub Notifications on your menu bar";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pineapplehunter ];
    platforms = lib.platforms.all;
  };
})
