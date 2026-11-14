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
  version = "5.1.3";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "bitfocus";
    repo = "companion";
    tag = "v${version}";
    hash = "sha256-drg4hvKL2yB+kg4BjOo7yg38UgOE0gUupMee4PAQD2w=";
  };

  passthru.updateScript = nix-update-script { };

  postPatch = ''
    # patch out git calls to generate version strings.
    substituteInPlace tools/lib.mts --replace-fail "return await fcn()" "return \"v${version}\" as unknown as T"

    # remove yarn config options which require network access at install time
    printf "nodeLinker: node-modules\nenableScripts: false\n" > .yarnrc.yml

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
    nodejs_26
    electron
    udev
  ];

  missingHashes = ./missing-hashes.json;

  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit src missingHashes;
    hash = "sha256-tUSNx846Lc3Gjgd+mgUfWFmsYgbnrDtd2aW1d2VhcUk=";
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

    # tools/build/package.mts runs a second `yarn install` in dist/ for the native
    # dependencies; resolve it from the offline cache set up by yarnBerryConfigHook
    export YARN_ENABLE_NETWORK=0
    export YARN_CACHE_FOLDER="$PWD/.yarn/cache"

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
