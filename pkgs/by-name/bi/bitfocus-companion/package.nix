{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchurl,
  nodejs_26,
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
      url = "https://s4.bitfocus.io/developer-module-builds/surface/elgato-stream-deck/v1.4.6-c7ea9961c73fc6bf184b563d03c64b5607312d8d/elgato-stream-deck-v1.4.6.tgz";
      hash = "sha256-0zYgn2ao2yhy3CSlHbdqfV9YWWwUiQ5kibDjT4uqOn8=";
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
  version = "5.0.5";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "bitfocus";
    repo = "companion";
    tag = "v${version}";
    hash = "sha256-Q5XQ/r4YYYqLk6YaSlBZqcqEH8nFmpqyzMf7/fMWX74=";
  };

  passthru.updateScript = nix-update-script { };

  postPatch = ''
    # patch out git calls to generate version strings.
    substituteInPlace tools/lib.mts --replace-fail "return await fcn()" "return \"v${version}\" as unknown as T"

    # remove yarn config options which require network access at install time
    printf "nodeLinker: node-modules\nenableScripts: false\n" > .yarnrc.yml

    # remove the yarn install during the build, since there is no internet connection, and everything has already been installed by yarnBerryConfigHook
    substituteInPlace tools/build/package.mts --replace-fail "await $\`yarn install --no-immutable\`" ""

    # remove node download, since we'll use the nix version
    substituteInPlace tools/build/package.mts \
      --replace-fail "const nodeVersions = await fetchNodejs(platformInfo)" "const nodeVersions: [string, string][] = []" \
      --replace-fail "await fs.createSymlink(latestRuntimeDir, path.join(runtimesDir, 'main'), 'dir')" ""

    substituteInPlace companion/lib/Instance/NodePath.ts \
      --replace-fail "if (!(await fs.pathExists(nodePath))) return null" "return '${lib.getExe nodejs_26}'"

    # allow all surface modules (builtin and user-downloaded) to find libudev, by adding
    # LD_LIBRARY_PATH to the env whitelist companion uses when spawning module child processes
    substituteInPlace companion/lib/Instance/Environment.ts \
      --replace-fail "'DISABLE_IPV6'," "'DISABLE_IPV6', 'LD_LIBRARY_PATH',"
  '';

  nativeBuildInputs = [
    nodejs_26
    yarn-berry.yarnBerryConfigHook
    git
    python3
    yarn-berry
    makeWrapper
  ];

  buildInputs = [
    libusb1
    dart-sass
    nodejs_26
    electron
    udev
  ];

  missingHashes = ./missing-hashes.json;

  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit src missingHashes;
    hash = "sha256-Fuh/D3FVtm08h7pW+LHgrEiyN9vmCjy+WekfpIz/Xc4=";
  };

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
    SKIP_LAUNCH_CHECK = true;
    ELECTRON = 0;
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

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/bitfocus-companion
    cp -r * $out/share/bitfocus-companion/

    makeWrapper ${lib.getExe nodejs_26} $out/bin/bitfocus-companion \
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
