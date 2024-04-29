{
  lib,
  stdenv,
  mkYarnPackage,
  fetchFromGitHub,
  applyPatches,
  fetchYarnDeps,
  makeDesktopItem,
  copyDesktopItems,
  makeWrapper,
  wrapGAppsHook,
  electron,
}:

mkYarnPackage rec {
  pname = "koodo-reader";
  version = "1.6.6";

  src = applyPatches {
    src = fetchFromGitHub {
      owner = "troyeguo";
      repo = "koodo-reader";
      rev = "v${version}";
      hash = "sha256-g2bVm8LFeEIPaWlaxzMI0SrpM+79zQFzJ7Vs5CbWBT4=";
    };
    patches = [ ./update-react-i18next.patch ]; # Could be upstreamed
  };

  # should be copied from `koodo-reader.src`
  packageJSON = ./package.json;

  patches = [ ./fix-isdev.patch ];

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-VvYkotVb74zR9+/IWiQwOX/6RJf+xukpi7okRovfVzc=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
    wrapGAppsHook
  ];

  dontWrapGApps = true;

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  configurePhase = ''
    runHook preConfigure

    cp -r $node_modules node_modules
    chmod +w node_modules

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    export HOME=$(mktemp -d)
    yarn --offline build
    yarn --offline run electron-builder --dir \
      -c.electronDist=${electron}/libexec/electron \
      -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 assets/icons/256x256.png $out/share/icons/hicolor/256x256/apps/koodo-reader.png
    install -Dm644 ${./mime-types.xml} $out/share/mime/packages/koodo-reader.xml

    mkdir -p $out/share/lib/koodo-reader
    cp -r dist/*-unpacked/{locales,resources{,.pak}} $out/share/lib/koodo-reader

    runHook postInstall
  '';

  # we use makeShellWrapper instead of the makeBinaryWrapper provided by wrapGAppsHook for proper shell variable expansion
  postFixup = ''
    makeShellWrapper ${electron}/bin/electron $out/bin/koodo-reader \
      --add-flags $out/share/lib/koodo-reader/resources/app.asar \
      "''${gappsWrapperArgs[@]}" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      --inherit-argv0
  '';

  doDist = false;

  desktopItems = [
    (makeDesktopItem {
      name = "koodo-reader";
      desktopName = "Koodo Reader";
      exec = "koodo-reader %U";
      icon = "koodo-reader";
      comment = meta.description;
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
    broken = stdenv.isDarwin;
    changelog = "https://github.com/troyeguo/koodo-reader/releases/tag/v${version}";
    description = "A cross-platform ebook reader";
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
}
