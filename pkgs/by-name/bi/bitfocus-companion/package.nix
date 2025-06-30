{
  stdenv,
  lib,
  fetchFromGitHub,
  nodejs,
  git,
  python3,
  udev,
  yarn-berry_4,
  libusb1,
  dart-sass,
  electron_36,
  makeWrapper,
}:

let
  yarn-berry = yarn-berry_4;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "bitfocus-companion";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "bitfocus";
    repo = "companion";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mDzpmWBJJQboEFWOiP5AeNq/5oJNhOMVm1vbEMhQfA8=";
  };

  postPatch = ''
    # patch out git calls to generate version strings.
    substituteInPlace tools/lib.mts --replace-fail "return await fcn()" "return \"v${finalAttrs.version}\""

    # remove the yarn install during the build, since there is no internet connection, and everything has already been installed by yarnBerryConfigHook
    substituteInPlace tools/build/dist.mts \
      --replace-fail 'await $`yarn --cwd node_modules/better-sqlite3 prebuild-install --arch=''${platformInfo.nodeArch}`' ""

    substituteInPlace tools/build/package.mts --replace-fail "await $\`yarn install --no-immutable\`" ""

    # remove node download, since we'll use the nix version
    substituteInPlace tools/build/package.mts --replace-fail "const nodeVersions = await fetchNodejs(platformInfo)" "const nodeVersions = []"
    substituteInPlace tools/build/package.mts --replace-fail "await fs.createSymlink(latestRuntimeDir, path.join(runtimesDir, 'main'))" ""
  '';

  nativeBuildInputs = [
    nodejs
    yarn-berry.yarnBerryConfigHook
    git
    python3
    udev
    electron_36
    yarn-berry
    makeWrapper
  ];

  buildInputs = [
    libusb1
    dart-sass
    nodejs
  ];

  missingHashes = ./missing-hashes.json;

  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    hash = "sha256-8PmXmHaAafmo0NA8B6wm8PBamfScT7xdqWKLie0KMtU=";
  };

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
    SKIP_LAUNCH_CHECK = true;
    ELECTRON = 0;
  };

  configurePhase = ''
    runHook preConfigure
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    # force sass-embedded to use our own sass instead of the bundled one
    substituteInPlace node_modules/sass-embedded/dist/lib/src/compiler-path.js \
        --replace-fail 'compilerCommand = (() => {' 'compilerCommand = (() => { return ["${lib.getExe dart-sass}"];'

    yarn lindist

    runHook postBuild
  '';

  preInstall = ''
    # remove node runtime, since we will always use the nix node runtime
    rm -rf .cache/node-runtimes
    rm -rf dist/node-runtimes
  '';

  installPhase = ''
    runHook preInstall

    # setup udev rules
    install -Dm644 assets/linux/50-companion-desktop.rules -t $out/etc/udev/rules.d/

    mkdir -p $out/share/bitfocus-companion
    cp -r * $out/share/bitfocus-companion/

    makeWrapper ${lib.getExe nodejs} $out/bin/bitfocus-companion \
      --add-flags $out/share/bitfocus-companion/dist/main.js \
      --set LD_LIBRARY_PATH "${libusb1}/lib" \
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
})
