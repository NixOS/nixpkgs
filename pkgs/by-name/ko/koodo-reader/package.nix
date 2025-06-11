{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  makeDesktopItem,

  copyDesktopItems,
  cctools,
  makeWrapper,
  nodejs,
  yarnConfigHook,
  yarnBuildHook,
  wrapGAppsHook3,
  xcbuild,

  electron,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "koodo-reader";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "troyeguo";
    repo = "koodo-reader";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BGzFJTtSCejTZYr61KNTwxr/S1YIox1iRwb8s9TH3OI=";
  };

  offlineCache = fetchYarnDeps {
    inherit (finalAttrs) src;
    hash = "sha256-fvsoh7wGfDYg3JVjhMPaI13ChXi45w0jc9g9fNthJgg=";
  };

  nativeBuildInputs =
    [
      makeWrapper
      nodejs
      (nodejs.python.withPackages (ps: [ ps.setuptools ]))
      yarnConfigHook
      yarnBuildHook
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
      copyDesktopItems
      wrapGAppsHook3
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      cctools
      xcbuild
    ];

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  # disable code signing on Darwin
  env.CSC_IDENTITY_AUTO_DISCOVERY = "false";

  postBuild = ''
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    # this is just the cpu-features install script without the node-gyp rebuild part
    # we cannot rebuild yet, because we haven't fixed the nan headers (see below)
    node node_modules/cpu-features/buildcheck.js > node_modules/cpu-features/buildcheck.gypi

    export npm_config_nodedir=${electron.headers}
    yarn --offline postinstall # fixup nan headers to work with electron and rebuild native libs

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

  dontWrapGApps = true;

  # we use makeShellWrapper instead of the makeBinaryWrapper provided by wrapGAppsHook for proper shell variable expansion
  postFixup = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    makeShellWrapper ${lib.getExe electron} $out/bin/koodo-reader \
      --add-flags $out/share/lib/koodo-reader/resources/app.asar \
      "''${gappsWrapperArgs[@]}" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
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
    changelog = "https://github.com/troyeguo/koodo-reader/releases/tag/${finalAttrs.src.tag}";
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
