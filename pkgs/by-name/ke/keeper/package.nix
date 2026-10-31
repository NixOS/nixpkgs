{
  lib,
  stdenv,
  fetchFromGitHub,
  yarn-berry_4,
  nodejs,
  electron_43,
  cacert,
  python3,
  pkg-config,
  libsecret,
  zip,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
}:

let
  # Keep this major version in sync with the node-abi entry added in buildPhase.
  electron = electron_43;
  yarn-berry = yarn-berry_4;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "keeper";
  version = "26.6.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "tonkeeper";
    repo = "tonkeeper-web";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SlCXarHSYMWiJTzT6Tkor7kckbbYj9yW2LcCTtZAn0Q=";
  };

  # Upstream uses Yarn 4.3.0. This migrates its lockfile and security settings
  # for nixpkgs' Yarn 4.14, whose built-in TypeScript patches also have new hashes.
  patches = [ ./yarn-4.14-support.patch ];

  # Supply hashes omitted from the lockfile for optional and platform-specific npm dependencies.
  missingHashes = ./missing-hashes.json;
  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes patches;
    hash = "sha256-Z5SceCAuG9YUCcoS/DPQpHNrP/FigfDuoqxRuzAJXCQ=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
    nodejs
    pkg-config
    python3
    yarn-berry
    yarn-berry.yarnBerryConfigHook
    zip
  ];

  buildInputs = [ libsecret ];

  env = {
    # Fail if dependency resolution would change the prepared lockfile.
    YARN_ENABLE_IMMUTABLE_INSTALLS = "1";

    # Electron Forge is redirected to the local nixpkgs distribution below.
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

    # Turbo initializes its TLS client even when remote caching is disabled.
    SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
    TURBO_TELEMETRY_DISABLED = "1";

    # Skip monorepo-wide lifecycle scripts; Forge rebuilds native modules from source later.
    YARN_ENABLE_SCRIPTS = "0";
  };

  postPatch = ''
    substituteInPlace package.json apps/desktop/package.json \
      --replace-fail '"version": "0.0.0"' '"version": "${finalAttrs.version}"'

    # Match Electron's Linux application ID to the desktop file installed below.
    node <<'EOF'
    const fs = require('fs');
    const path = 'apps/desktop/package.json';
    const manifest = JSON.parse(fs.readFileSync(path));
    manifest.desktopName = 'keeper.desktop';
    fs.writeFileSync(path, JSON.stringify(manifest, null, 4) + '\n');
    EOF

    # Do not let @electron/rebuild download prebuilt native modules such as keytar.
    substituteInPlace apps/desktop/forge.config.ts \
      --replace-fail 'rebuildConfig: {},' 'rebuildConfig: { buildFromSource: true },'

    # Updates are provided by nixpkgs.
    substituteInPlace apps/desktop/src/index.ts \
      --replace-fail "import { updateElectronApp } from 'update-electron-app';" "" \
      --replace-fail 'updateElectronApp({ logger: log });' ""
  '';

  buildPhase = ''
    runHook preBuild

    export npm_config_nodedir=${electron.headers}
    patchShebangs apps/desktop/node_modules

    # Build native modules against nixpkgs' Electron and make Electron Forge use
    # that version and distribution instead of downloading its own copy.
    substituteInPlace apps/desktop/node_modules/@electron-forge/core-utils/dist/electron-version.js \
      --replace-fail "return version" "return '${electron.version}'"

    # The node-abi release in Keeper's lock file predates Electron 43. Keep the
    # ABI and target synchronized with electron_43 above (`electron --abi`: 148).
    node <<'EOF'
    const fs = require('fs');
    const path = 'apps/desktop/node_modules/node-abi/abi_registry.json';
    const registry = JSON.parse(fs.readFileSync(path));
    registry.push({
      abi: '148',
      future: true,
      lts: false,
      runtime: 'electron',
      target: '43.0.0-alpha.1',
    });
    fs.writeFileSync(path, JSON.stringify(registry, null, 2) + '\n');
    EOF

    # Packager requires an Electron zip. Build it from nixpkgs' distribution and
    # replace the download call with its absolute path in the build sandbox.
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist
    pushd electron-dist
    zip -0Xqr ../electron.zip .
    popd
    rm -r electron-dist

    substituteInPlace apps/desktop/node_modules/@electron/packager/dist/packager.js \
      --replace-fail 'await this.getElectronZipPath(downloadOpts)' "\"$PWD/electron.zip\""

    # The desktop bundle imports the generated core, locales, and UI kit packages.
    yarn turbo build:pkg --concurrency="$NIX_BUILD_CORES"

    # Forge needs its non-interactive renderer for readable Nix build logs.
    CI=1 yarn workspace @tonkeeper/desktop electron-forge package \
      --platform=linux

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # Keep Forge's application resources, but run them with nixpkgs' Electron.
    mkdir -p $out/share/keeper
    cp -r apps/desktop/out/Tonkeeper-linux-*/resources $out/share/keeper/

    # Electron selects Ozone's backend automatically. Enable the remaining Wayland
    # integrations only if NIXOS_OZONE_WL is set and a Wayland display exists.
    makeWrapper ${lib.getExe electron} $out/bin/keeper \
      --add-flags $out/share/keeper/resources/app.asar \
      --set ELECTRON_FORCE_IS_PACKAGED 1 \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --inherit-argv0
    ln -s keeper $out/bin/tonkeeper

    install -Dm444 apps/desktop/public/icon.png \
      $out/share/icons/hicolor/512x512/apps/keeper.png

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "keeper";
      desktopName = "Keeper";
      genericName = "Cryptocurrency Wallet";
      comment = "Self-custodial cryptocurrency wallet";
      exec = "keeper %u";
      icon = "keeper";
      startupWMClass = "keeper";
      categories = [
        "Office"
        "Finance"
      ];
      mimeTypes = [
        "x-scheme-handler/ton"
        "x-scheme-handler/tc"
        "x-scheme-handler/tonkeeper"
        "x-scheme-handler/tonkeeper-tc"
        "x-scheme-handler/tonkeeper-pro"
        "x-scheme-handler/tonkeeper-pro-tc"
      ];
    })
  ];

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Self-custodial cryptocurrency wallet";
    longDescription = ''
      Keeper is a self-custodial cryptocurrency wallet formerly known as
      Tonkeeper.
    '';
    homepage = "https://keeperwallet.com/";
    changelog = "https://github.com/tonkeeper/tonkeeper-web/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ starius ];
    mainProgram = "keeper";
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
})
