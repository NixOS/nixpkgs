{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchurl,
  nodejs,
  git,
  python3,
  udev,
  yarn-berry_4,
  libusb1,
  dart-sass,
  electron,
  makeWrapper,
  nix-update-script,
}:

let
  yarn-berry = yarn-berry_4;

  builtinSurfaces = {
    elgato-stream-deck = fetchurl {
      url = "https://s4.bitfocus.io/developer-module-builds/surface/elgato-stream-deck/v1.4.3-70e2c01d15a0f58c52a8e80d7d6f4977f157d58e/elgato-stream-deck-v1.4.3.tgz";
      hash = "sha256-bZnXvkyfllzHZTAJtH/hSYIv+J5ZOYWZycUHdz9srGI=";
    };
    xkeys = fetchurl {
      url = "https://s4.bitfocus.io/developer-module-builds/surface/xkeys/v1.0.2-876f00ee194faa57ec14468b7019bbaa516a9e6d/xkeys-v1.0.2.tgz";
      hash = "sha256-LYJD0Wb90hIIs8AIiZoqLxxKtMWko9rryPSds9ZYCac=";
    };
  };

  selectSystem =
    attrs:
    attrs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  platform = selectSystem {
    x86_64-linux = "linux-x64";
    aarch64-linux = "linux-arm64";
    armv7l-linux = "linux-armv7l";
  };
in

stdenv.mkDerivation rec {
  pname = "bitfocus-companion";
  version = "4.3.4";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "bitfocus";
    repo = "companion";
    tag = "v${version}";
    hash = "sha256-ojSXiWaRKFCjHmAMs/RtzNhgSNUy7RKTZ4CE/wCxEaI=";
  };

  passthru.updateScript = nix-update-script { };

  postPatch = ''
    # patch out git calls to generate version strings.
    substituteInPlace tools/lib.mts --replace-fail "return await fcn()" "return \"v${version}\" as unknown as T"

    # remove unsupported yarn config options (npmMinimalAgeGate, npmPreapprovedPackages removed in newer yarn)
    # approvedGitRepositories and compressionLevel required by yarn >= 4.14 for lockfile version < 9
    printf "nodeLinker: node-modules\nenableScripts: false\ncompressionLevel: 0\napprovedGitRepositories:\n  - '**'\n" > .yarnrc.yml

    # remove the yarn install during the build, since there is no internet connection, and everything has already been installed by yarnBerryConfigHook
    substituteInPlace tools/build/dist.mts \
      --replace-fail 'await $`yarn --cwd node_modules/better-sqlite3 prebuild-install --arch=''${platformInfo.nodeArch} --platform=''${platformInfo.nodePlatform}`' "" \
      --replace-fail 'await $`yarn --cwd node_modules/better-sqlite3 prebuild-install`' ""

    substituteInPlace tools/build/package.mts --replace-fail "await $\`yarn install --no-immutable\`" ""

    # remove node download, since we'll use the nix version
    substituteInPlace tools/build/package.mts \
      --replace-fail "const nodeVersions = await fetchNodejs(platformInfo)" "const nodeVersions: [string, string][] = []" \
      --replace-fail "await fs.createSymlink(latestRuntimeDir, path.join(runtimesDir, 'main'), 'dir')" ""

    substituteInPlace companion/lib/Instance/NodePath.ts \
      --replace-fail "if (!(await fs.pathExists(nodePath))) return null" "return '${lib.getExe nodejs}'" \
  '';

  nativeBuildInputs = [
    nodejs
    yarn-berry.yarnBerryConfigHook
    git
    python3
    yarn-berry
    makeWrapper
  ];

  buildInputs = [
    libusb1
    dart-sass
    nodejs
    electron
    udev
  ];

  missingHashes = ./missing-hashes.json;

  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit src missingHashes;
    hash = "sha256-XDXxv+LSr9fYhVhwkcvmd56fAL6gY9FK6kiQlXxTWXo=";
  };

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
    SKIP_LAUNCH_CHECK = true;
    ELECTRON = 0;
    # prevent yarn >= 4.14 from triggering a lockfile refresh for v8 lockfiles
    YARN_LOCKFILE_VERSION_OVERRIDE = 8;
  };

  # with dontConfigure it doesn't seem to retrieve node_modules, so empty configurePhase instead
  configurePhase = ''
    runHook preConfigure
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    # force sass-embedded to use our own sass instead of the bundled one
    substituteInPlace node_modules/sass-embedded/dist/lib/src/compiler-path.js \
        --replace-fail 'compilerCommand = (() => {' 'compilerCommand = (() => { return ["${lib.getExe dart-sass}"];'

    # pre-populate builtin surface module cache to avoid network access during build
    mkdir -p .cache/builtin-surfaces/elgato-stream-deck
    tar -xzf ${builtinSurfaces.elgato-stream-deck} --strip-components=1 -C .cache/builtin-surfaces/elgato-stream-deck
    mkdir -p .cache/builtin-surfaces/xkeys
    tar -xzf ${builtinSurfaces.xkeys} --strip-components=1 -C .cache/builtin-surfaces/xkeys
    sha256sum assets/builtin-surface-modules.json | awk '{print $1}' > .cache/builtin-surfaces-checksum.txt

    yarn dist ${platform}

    runHook postBuild
  '';

  preInstall = ''
    # remove node runtime, since we will always use the nix node runtime
    rm -rf .cache/node-runtimes
    rm -rf dist/node-runtimes
  '';

  postInstall = ''
    # patch the env whitelist companion uses when spawning module child processes to include
    # LD_LIBRARY_PATH, so all surface modules (builtin and user-downloaded) can find libudev
    substituteInPlace $out/share/bitfocus-companion/dist/main.js \
      --replace-fail '"DISABLE_IPV6"],t={}' '"DISABLE_IPV6","LD_LIBRARY_PATH"],t={}'
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/bitfocus-companion
    cp -r * $out/share/bitfocus-companion/

    makeWrapper ${lib.getExe nodejs} $out/bin/bitfocus-companion \
      --add-flags $out/share/bitfocus-companion/dist/main.js \
      --set LD_LIBRARY_PATH "${
        lib.makeLibraryPath [
          libusb1
          udev
        ]
      }" \
      --set NODE_PATH $out/share/bitfocus-companion/node_modules

    runHook postInstall
  '';

  meta = {
    description = "Program for controlling Stream Deck devices";
    longDescription = "Bitfocus Companion enables the Elgato Stream Deck and other controllers to be a professional shotbox surface for an increasing amount of different presentation switchers, video playback software and broadcast equipment.";
    homepage = "https://bitfocus.io/companion";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tiebe ];
    mainProgram = "bitfocus-companion";
    platforms = lib.platforms.linux;
  };
}
