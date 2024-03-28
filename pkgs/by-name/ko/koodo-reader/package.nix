{ lib
, mkYarnPackage
, fetchFromGitHub
, applyPatches
, fetchYarnDeps
, makeDesktopItem
, copyDesktopItems
, wrapGAppsHook
, gtk3
, electron
}:

mkYarnPackage rec {
  pname = "koodo-reader";
  version = "1.5.9";

  src = applyPatches {
    src = fetchFromGitHub {
      owner = "troyeguo";
      repo = pname;
      rev = "v${version}";
      hash = "sha256-SScbK3pJRqMQ14vj2z4Ek5eSfGxbWN5TYIWLFKRofFk=";
    };
    patches = [ ./update-react-i18next.patch ]; # Could be upstreamed
  };

  packageJSON = ./package.json;

  patches = [ ./fix-isdev.patch ];

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-YDnFJXeebvfpk5TSHS/0mg2INTHt1ZLfoo8lfG/bNgs=";
  };

  nativeBuildInputs = [ copyDesktopItems wrapGAppsHook ];

  dontWrapGApps = true;

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  configurePhase = ''
    cp -r $node_modules node_modules
    chmod +w node_modules
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

    install -Dm644 assets/icons/256x256.png $out/share/icons/hicolor/256x256/apps/${pname}.png
    install -Dm644 ${./mime-types.xml} $out/share/mime/packages/${pname}.xml

    mkdir -p $out/share/lib/${pname}
    cp -r dist/*-unpacked/{locales,resources{,.pak}} $out/share/lib/${pname}

    makeWrapper ${electron}/bin/electron $out/bin/${pname} \
      --add-flags $out/share/lib/${pname}/resources/app.asar \
      "''${gappsWrapperArgs[@]}" \
      --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      --inherit-argv0

    runHook postInstall
  '';

  doDist = false;
  dontFixup = true;

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      desktopName = "Koodo Reader";
      exec = "${pname} %U";
      icon = pname;
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
    changelog = "https://github.com/troyeguo/koodo-reader/releases/tag/v${version}";
    description = "A cross-platform ebook reader";
    longDescription = ''
      A modern ebook manager and reader with sync and backup capacities
      for Windows, macOS, Linux and Web
    '';
    homepage = "https://github.com/troyeguo/koodo-reader";
    license = lib.licenses.agpl3Only;
    mainProgram = pname;
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = electron.meta.platforms;
  };
}
