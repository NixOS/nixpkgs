{
  lib,
  stdenv,
  applyPatches,
  copyDesktopItems,
  electron,
  fetchFromGitHub,
  fetchurl,
  fetchYarnDeps,
  llvmPackages,
  makeWrapper,
  makeDesktopItem,
  nodejs,
  pkg-config,
  python3,
  ripgrep,
  yarnConfigHook,
  zip,

  arduino-cli,

  libdrm,
  libsecret,
  libx11,
  libxkbfile,

  clang_20,
  darwin,
  xcbuild,
}:
let
  inherit (stdenv.hostPlatform) system;

  # see the @electron/get fix in buildPhase below.
  electronPlatform =
    {
      x86_64-linux = "linux-x64";
      aarch64-linux = "linux-arm64";
      aarch64-darwin = "darwin-arm64";
    }
    .${system} or (throw "arduino-ide: unsupported platform ${system}");

  # seperate tools fetched as binary
  arduinoToolPlatform =
    {
      x86_64-linux = "Linux_64bit";
      aarch64-linux = "Linux_ARM64";
      aarch64-darwin = "macOS_ARM64";
    }
    .${system} or (throw "arduino-ide: unsupported platform ${system}");

  arduino-fwuploader-bin = fetchurl {
    url = "https://downloads.arduino.cc/arduino-fwuploader/arduino-fwuploader_2.4.1_${arduinoToolPlatform}.tar.gz";
    hash =
      {
        x86_64-linux = "sha256-oh6nWW0LiDsk/Am8/DAA86d7GVAE61CPmi3rcAA/U44=";
        aarch64-linux = "sha256-AEEnFaTR3KSypSS/2fhWvAqvvdHRTIuAVUP8+dYyyhg=";
        aarch64-darwin = "sha256-gvRdlgsdDWEwAjLkfDlMhlI3yNcKm/hShd5KngziXnI=";
      }
      .${system};
  };

  # normally cloned via git by arduino-ide-extension/scripts/download-examples.js.
  arduino-examples-src = fetchFromGitHub {
    owner = "arduino";
    repo = "arduino-examples";
    tag = "1.10.3";
    hash = "sha256-ZaUmof7M4x9PTrdsPas4XqxqC4QKDCPe8vIiV0KUM7Q=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "arduino-ide";
  version = "2.3.10";

  src = applyPatches {
    src = fetchFromGitHub {
      owner = "arduino";
      repo = "arduino-ide";
      tag = finalAttrs.version;
      hash = "sha256-zrDdrIzO7AEMSW8JGPnAN+4DGqznfFkCxha5C8K4xKA=";
    };
    patches = [ ./update-dependencies.patch ];
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-2SRdPCLRyh2X62npjbSmWfiafw03wsJ9XoaA1W9v4HU=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    PUPPETEER_SKIP_DOWNLOAD = "1";
    ELECTRON_OVERRIDE_DIST_PATH = "node_modules/electron/dist";
    THEIA_ELECTRON_SKIP_REPLACE_FFMPEG = "1";
    CI = "true";
  };

  nativeBuildInputs = [
    yarnConfigHook
    nodejs
    makeWrapper
    copyDesktopItems
    pkg-config
    python3
    zip
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    clang_20 # newer clang breaks node-addon-api on darwin
    darwin.autoSignDarwinBinariesHook
    xcbuild
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    libdrm
    libsecret
    libx11
    libxkbfile
  ];

  buildPhase = ''
    runHook preBuild

    # manual placement of required resources
    RESOURCES=arduino-ide-extension/src/node/resources
    mkdir -p "$RESOURCES"
    mkdir "$RESOURCES/Examples"
    yarn --cwd arduino-ide-extension --offline copy-i18n
    tar -xzf ${arduino-fwuploader-bin} -C "$RESOURCES"
    chmod +x "$RESOURCES"/arduino-fwuploader
    cp ${llvmPackages.clang-tools}/bin/{clangd,clang-format} "$RESOURCES/"
    cp ${arduino-cli}/bin/arduino-cli "$RESOURCES/"
    cp -r ${arduino-examples-src}/examples/. "$RESOURCES/Examples/"
    node ${./generate-examples-json.js} "$RESOURCES/Examples"

    # Put ripgrep binary into bin, so post-install does not try to download it.
    find -name ripgrep -type d \
      -execdir mkdir -p {}/bin \; \
      -execdir ln -s ${ripgrep}/bin/rg {}/bin/rg \;

    # rebuild the extension's native addons against plain nodejs first
    export npm_config_nodedir="${nodejs}"
    npm rebuild --verbose --no-progress --offline \
      @parcel/watcher \
      @theia/ffmpeg \
      drivelist \
      keytar \
      msgpackr-extract \
      native-keymap \
      node-pty

    mkdir -p node_modules/electron
    cp -R ${electron.dist} node_modules/electron/dist
    chmod -R u+w node_modules/electron/dist
    echo -n "${electron.version}" > node_modules/electron/dist/version

    # stop theia from checking for proprietary codecs
    cat <<EOF > node_modules/@theia/ffmpeg/lib/check-ffmpeg.js
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    exports.checkFfmpeg = async () => {};
    EOF

    # stop @electron/get from trying to download electron
    ELECTRON_ZIP="$PWD/electron-v${electron.version}-${electronPlatform}.zip"
    zip -r "$ELECTRON_ZIP" node_modules/electron/dist
    cat <<EOF > node_modules/@electron/get/dist/cjs/index.js
    exports.downloadArtifact = async () => "$ELECTRON_ZIP";
    exports.download = async () => "$ELECTRON_ZIP";
    EOF

    yarn --verbose --no-progress --offline build

    pushd electron-app

    # rebuild electron-app's native addons against electron headers
    export npm_config_nodedir=${electron.headers}
    yarn --verbose --no-progress --offline rebuild
    yarn --verbose --no-progress --offline build

    npm exec electron-builder -- \
      --publish=never \
      --dir \
      ${lib.optionalString stdenv.hostPlatform.isDarwin "-c.mac.identity=null"} \
      -c.electronDist=../node_modules/electron/dist \
      -c.electronVersion=${electron.version} \
      -c.extraMetadata.version=${finalAttrs.version} \
      -c.extraMetadata.name=arduino-ide \
      -c.extraMetadata.theia.frontend.config.appVersion=${finalAttrs.version} \
      -c.extraMetadata.theia.frontend.config.cliVersion=${arduino-cli.version} \
      -c.extraMetadata.theia.frontend.config.buildDate=$(date -u +%Y-%m-%dT%H:%M:%S.000Z) \
      -c.extraMetadata.main=./arduino-ide-electron-main.js

    popd

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

  ''
  + (
    if stdenv.hostPlatform.isDarwin then
      ''
        mkdir -p $out/{Applications,bin}
        cp -r electron-app/dist/mac*/"Arduino IDE.app" $out/Applications
        makeWrapper $out/Applications/"Arduino IDE.app"/Contents/MacOS/"Arduino IDE" $out/bin/arduino-ide
      ''
    else
      ''
        mkdir -p $out/share/lib/arduino-ide
        cp -r electron-app/dist/*-unpacked/{locales,resources{,.pak}} $out/share/lib/arduino-ide
        install -Dm444 electron-app/resources/icons/512x512.png $out/share/icons/hicolor/512x512/apps/arduino-ide.png

        makeWrapper ${electron}/bin/electron $out/bin/arduino-ide \
          --add-flags $out/share/lib/arduino-ide/resources/app \
          --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
          --inherit-argv0
      ''
  )
  + ''

    runHook postInstall
  '';

  desktopItems = lib.optionals stdenv.hostPlatform.isLinux [
    (makeDesktopItem {
      name = "arduino-ide";
      exec = "arduino-ide";
      icon = "arduino-ide";
      desktopName = "Arduino IDE";
      comment = finalAttrs.meta.description;
      categories = [ "Development" ];
      startupWMClass = "arduino-ide";
    })
  ];

  meta = {
    description = "Open-source electronics prototyping platform";
    homepage = "https://www.arduino.cc/en/software";
    changelog = "https://github.com/arduino/arduino-ide/releases/tag/${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    mainProgram = "arduino-ide";
    maintainers = with lib.maintainers; [
      clerie
      ern775
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
})
