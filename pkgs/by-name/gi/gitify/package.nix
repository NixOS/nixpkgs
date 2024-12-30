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
  version = "5.17.0";

  src = fetchFromGitHub {
    owner = "gitify-app";
    repo = "gitify";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-l89CXfARLBNS6MMq54gM63y5FqeHdMXDBt52znir+/A=";
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
    hash = "sha256-I78AvOBdDd59eVJJ51xxNwVvMnNvLdJJpFEtE/I1H8U=";
  };

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = 1;

  postPatch = ''
    substituteInPlace package.json \
      --replace-fail '"Emmanouil Konstantinidis (3YP8SXP3BF)"' null \
      --replace-fail '"scripts/notarize.js"' null
  '';

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
