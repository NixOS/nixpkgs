{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  nodejs,
  makeDesktopItem,
  copyDesktopItems,
  makeWrapper,
  wrapGAppsHook3,
  electron,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "koodo-reader";
  version = "1.6.7";

  src = fetchFromGitHub {
    owner = "troyeguo";
    repo = "koodo-reader";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ZHRU8dJjKQFLIB1t2VK/COy6a3nShUeWR8iAM9YJdto=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-58mxYt2wD6SGzhvo9c44CPmdX+/tLnbJCMPafo4txbY=";
  };

  nativeBuildInputs =
    [
      makeWrapper
      yarnConfigHook
      yarnBuildHook
      nodejs
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
      copyDesktopItems
      wrapGAppsHook3
    ];

  dontWrapGApps = true;

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  # disable code signing on Darwin
  env.CSC_IDENTITY_AUTO_DISCOVERY = "false";

  postBuild = ''
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist
    yarn --offline run electron-builder --dir \
      -c.electronDist=electron-dist \
      -c.electronVersion=${electron.version}
  '';

  installPhase = ''
    runHook preInstall

    ${lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
      install -Dm644 assets/icons/256x256.png $out/share/icons/hicolor/256x256/apps/koodo-reader.png
      install -Dm644 ${./mime-types.xml} $out/share/mime/packages/koodo-reader.xml

      mkdir -p $out/share/lib/koodo-reader
      cp -r dist/*-unpacked/{locales,resources{,.pak}} $out/share/lib/koodo-reader
    ''}

    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p $out/Applications
      cp -r dist/mac*/"Koodo Reader.app" $out/Applications
      makeWrapper "$out/Applications/Koodo Reader.app/Contents/MacOS/Koodo Reader" $out/bin/koodo-reader
    ''}

    runHook postInstall
  '';

  # we use makeShellWrapper instead of the makeBinaryWrapper provided by wrapGAppsHook for proper shell variable expansion
  postFixup = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    makeShellWrapper ${lib.getExe electron} $out/bin/koodo-reader \
      --add-flags $out/share/lib/koodo-reader/resources/app.asar \
      "''${gappsWrapperArgs[@]}" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      --set-default ELECTRON_IS_DEV 0 \
      --inherit-argv0
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "koodo-reader";
      desktopName = "Koodo Reader";
      exec = "koodo-reader %U";
      icon = "koodo-reader";
      comment = finalAttrs.meta.description;
      categories = [ "Office" ];
      mimeTypes = [
        "application/epub+zip"
        "application/pdf"
        "image/vnd.djvu"
        "application/x-mobipocket-ebook"
        "application/vnd.amazon.ebook"
        "application/vnd.amazon.ebook"
        "application/x-cbz"
        "application/x-cbr"
        "application/x-cbt"
        "application/x-cb7"
        "application/x-fictionbook+xml"
      ];
      startupWMClass = "Koodo Reader";
      terminal = false;
    })
  ];

  meta = {
    changelog = "https://github.com/troyeguo/koodo-reader/releases/tag/v${finalAttrs.version}";
    description = "Cross-platform ebook reader";
    longDescription = ''
      A modern ebook manager and reader with sync and backup capacities
      for Windows, macOS, Linux and Web
    '';
    homepage = "https://github.com/troyeguo/koodo-reader";
    license = lib.licenses.agpl3Only;
    mainProgram = "koodo-reader";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = electron.meta.platforms;
  };
})
