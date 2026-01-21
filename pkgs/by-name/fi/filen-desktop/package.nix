{
  lib,
  pkgs,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  makeDesktopItem,
  copyDesktopItems,
  imagemagick,
  makeWrapper,
  electron,
}:
let
  packageName = "filen-desktop";
  packageVersion = "3.0.47";
  desktopName = "Filen Desktop";
  appName = "Filen";

  desktopItem = makeDesktopItem {
    name = packageName;
    exec = packageName;
    icon = packageName;
    startupWMClass = packageName;
    desktopName = desktopName;
    comment = "Encrypted Cloud Storage";
    categories = [
      "Network"
      "FileTransfer"
      "Utility"
    ];
    keywords = [
      "cloud"
      "storage"
      "encrypted"
    ];
  };
in
buildNpmPackage {
  pname = packageName;
  version = packageVersion;
  makeCacheWritable = true;

  src = fetchFromGitHub {
    owner = "FilenCloudDienste";
    repo = packageName;
    rev = "v${packageVersion}";
    hash = "sha256-WS9JqErfsRtt6zF+LrKkpiscJ25MRXmRxmIm3GH6xf0=";
  };

  npmDepsHash = "sha256-+Ul2z6faZvAeCHq35janVTUNoqTQ5JNDeLbCV220nFU=";

  nativeBuildInputs = [
    pkgs.pkg-config
    makeWrapper
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    copyDesktopItems
    imagemagick
  ];

  buildInputs = [
    pkgs.pixman
    pkgs.cairo
    pkgs.pango
  ];

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
  env.PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";

  postPatch = ''
    # Use nixpkgs electron instead of downloading
    substituteInPlace package.json \
      --replace-fail '"electron": "^34.1.1"' '"electron": "*"'

    # Disable code signing (not needed for Nix)
    substituteInPlace package.json \
      --replace-fail '"afterSign": "build/notarize.js",' ""

    # Fix app name and userData paths inside filen-desktop app source
    substituteInPlace src/index.ts \
      --replace-fail 'const options = await this.options.get()' \ '
      app.setName("${desktopName}")
      app.setPath("userData", pathModule.join(app.getPath("appData"), "@filen", "desktop"))
      const options = await this.options.get()
    '
  '';

  buildPhase = ''
    runHook preBuild

    # Compile TypeScript
    npm run build

    # Prepare nixpkgs electron for electron-builder
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    # Build platform bundle
    npx electron-builder \
      --dir \
      --${if stdenv.hostPlatform.isDarwin then "mac" else "linux"} \
      -c.electronDist=electron-dist \
      -c.electronVersion="${electron.version}"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ${
      if stdenv.hostPlatform.isDarwin then
        ''
          # Install macOS .app bundle
          mkdir -p $out/Applications
          cp -r prod/mac*/${appName}.app $out/Applications/

          # Create bin symlink
          mkdir -p $out/bin
          makeWrapper "$out/Applications/${appName}.app/Contents/MacOS/${appName}" $out/bin/${packageName}
        ''
      else
        ''
          # Copy built resources
          mkdir -p $out/share/${packageName}
          cp -r prod/*-unpacked/{locales,resources{,.pak}} $out/share/${packageName}

          # Create desktop icon
          mkdir -p $out/share/icons/hicolor/256x256/apps
          magick assets/icons/app/linux.png -resize 256x256 $out/share/icons/hicolor/256x256/apps/${packageName}.png

          # Create launcher with electron
          makeWrapper ${lib.getExe electron} $out/bin/${packageName} \
            --set ELECTRON_IS_DEV 0 \
            --add-flags $out/share/${packageName}/resources/app.asar \
            --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
            --inherit-argv0
        ''
    }

    runHook postInstall
  '';

  desktopItems = lib.optionals (!stdenv.hostPlatform.isDarwin) [ desktopItem ];

  meta = {
    homepage = "https://filen.io/products";
    downloadPage = "https://filen.io/products/desktop";
    description = "Filen Desktop Client";
    longDescription = ''
      Encrypted Cloud Storage built for your Desktop.
      Sync your data, mount network drives, collaborate with others and access files natively powered by robust encryption and seamless integration.
    '';
    mainProgram = packageName;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      smissingham
      kashw2
    ];
  };
}
