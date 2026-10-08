{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  makeDesktopItem,
  copyDesktopItems,
  makeWrapper,
  electron,
  libicns,
  pkg-config,
  pixman,
  cairo,
  pango,
  rclone,
}:
let
  packageName = "filen-desktop";
  packageVersion = "3.0.53";
  desktopName = "Filen Desktop";
  appName = "Filen";
  rcloneArch = if stdenv.hostPlatform.isAarch64 then "arm64" else "amd64";
  rcloneOs = if stdenv.hostPlatform.isDarwin then "osx" else "linux";

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
    hash = "sha256-uWh9/HOqSlin5kgVErLjRMHBZFY+eNxkKDKk4/AGUdg=";
  };

  npmDepsHash = "sha256-sUQSt6e8UpipNm+BaeVbY8/v7fp3tUPhGXPbEVKH6a0";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ libicns ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    copyDesktopItems
  ];

  buildInputs = [
    pixman
    cairo
    pango
  ];

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
  };

  postPatch = ''
    # use electron version supplied by nixpkgs.
    substituteInPlace package.json \
      --replace-fail '"electron": "^43.0.0"' '"electron": "*"'

    # only package rclone for host architecture
    substituteInPlace build/afterPack.js \
      --replace-fail '[`rclone-''${osToken}-amd64''${ext}`, `rclone-''${osToken}-arm64''${ext}`]' \
        '[`rclone-''${osToken}-${rcloneArch}''${ext}`]'

    # expect externally installed FUSE drivers.
    substituteInPlace src/lib/rclone/manager.ts \
      --replace-fail 'tryInstallDependencies: true,' 'tryInstallDependencies: false,'

    # fix app name and userData paths inside app source
    substituteInPlace src/index.ts \
      --replace-fail 'const options = await this.options.get()' \ '
      app.setName("${desktopName}")
      app.setPath("userData", pathModule.join(app.getPath("appData"), "@filen", "desktop"))
      const options = await this.options.get()
    '

    # skip upstream DMG notarization hook.
    substituteInPlace package.json \
      --replace-fail '"afterAllArtifactBuild": "build/notarize-dmg.js",' ""

    # use conventional macOS icon to bypass Xcode 26's actool.
    substituteInPlace package.json \
      --replace-fail '"icon": "build/icons/mac/icon.icon"' '"icon": "build/icons/mac/icon.icns"'
    substituteInPlace build/afterPack.js \
      --replace-fail '["Assets.car", "icon.icns"]' '["icon.icns"]'
  '';

  buildPhase = ''
    runHook preBuild

    # Verify the bundled rclone meets Filen's expected version.
    expectedRcloneVersion=$(sed -n 's/^export const RCLONE_VERSION = "\([^"]*\)"$/\1/p' src/lib/rclone/constants.ts)
    if [ -z "$expectedRcloneVersion" ] || ! printf '%s\n' "$expectedRcloneVersion" "${rclone.version}" | sort -V -C; then
      echo "rclone version requirement not met: nixpkgs=${rclone.version}, Filen requires >= ''${expectedRcloneVersion:-not found}" >&2
      exit 1
    fi

    # Run upstream validation and compile TypeScript.
    npm run build

    # Prepare nixpkgs imported electron and rclone for packaging.
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist
    install -Dm755 ${lib.getExe rclone} bin/rclone/rclone-${rcloneOs}-${rcloneArch}

    # Generate the macOS icon from the upstream PNG assets.
    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      png2icns build/icons/mac/icon.icns build/icons/png/{16x16,32x32,128x128,256x256,512x512,1024x1024}.png
    ''}

    # Build the platform bundle.
    npx electron-builder \
      --dir \
      --${if stdenv.hostPlatform.isDarwin then "mac" else "linux"} \
      ${lib.optionalString stdenv.hostPlatform.isDarwin "-c.mac.identity=null"} \
      -c.electronDist=electron-dist \
      -c.electronVersion="${electron.version}"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ${
      if stdenv.hostPlatform.isDarwin then
        ''
          # Install the macOS application bundle.
          mkdir -p $out/Applications
          cp -r prod/mac*/${appName}.app $out/Applications/

          # Create the command-line launcher.
          mkdir -p $out/bin
          makeWrapper "$out/Applications/${appName}.app/Contents/MacOS/${appName}" $out/bin/${packageName}
        ''
      else
        ''
          # Install the application resources.
          mkdir -p $out/share/${packageName}
          cp -r prod/*-unpacked/{locales,resources{,.pak}} $out/share/${packageName}

          # Install the desktop icon.
          mkdir -p $out/share/icons/hicolor/128x128/apps
          cp assets/icons/app/linux.png $out/share/icons/hicolor/128x128/apps/${packageName}.png

          # Create the launcher using nixpkgs Electron.
          makeWrapper ${lib.getExe electron} $out/bin/${packageName} \
            --set ELECTRON_IS_DEV 0 \
            --add-flags $out/share/${packageName}/resources/app.asar \
            --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
            --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ stdenv.cc.cc.lib ]}" \
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

      This package does not install or upgrade FUSE drivers.
      Network-drive mounting requires externally installed macFUSE or FUSE-T on macOS, or FUSE3 and a working fusermount3 helper on Linux.
    '';
    mainProgram = packageName;
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
      "aarch64-darwin"
    ];
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      smissingham
      kashw2
    ];
  };
}
