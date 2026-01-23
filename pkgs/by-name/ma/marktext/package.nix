{
  stdenv,
  fetchFromGitHub,
  lib,
  fetchYarnDeps,
  yarn,
  fixup-yarn-lock,
  nodejs,
  electron,
  python3,
  xorg,
  fontconfig,
  node-gyp-build,
  ripgrep,
  pkg-config,
  libsecret,
  yarnBuildHook,
  makeShellWrapper,
  unstableGitUpdater,
  xcbuild,
  libtool,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "marktext";
  version = "0.17.0-unstable-2025-11-19";

  src = fetchFromGitHub {
    owner = "marktext";
    repo = "marktext";
    rev = "aa71e33e07845419533d767ad0d260a7c267cec7";
    hash = "sha256-c/MxYGFFCfC5KcvtBYuxSqeZ4WuAq5zPuBfYqXczicU=";
    postFetch = ''
      cd $out
      patch -p1 < ${./0001-update-electron.patch}
    ''; # Need for offlineCache
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-mr79FV/LHkoY3vX9B5yv95IQIJQ9akwfslKndKYmwCo=";
  };

  nativeBuildInputs = [
    yarn
    fixup-yarn-lock
    makeShellWrapper
    yarnBuildHook
    (python3.withPackages (ps: with ps; [ packaging ]))
    pkg-config
    nodejs
    node-gyp-build
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    xcbuild
    libtool
  ];

  buildInputs = [
    libsecret
    xorg.libX11
    xorg.libxkbfile
    fontconfig
    xorg.xorgproto
  ];

  postPatch = ''
    substituteInPlace src/common/filesystem/paths.js \
      --replace-fail "process.resourcesPath" "'$out/opt/marktext/resources'"

    substituteInPlace src/main/cli/index.js \
      --replace-fail "process.argv.slice(1)" "process.argv.slice(2)"
  '';

  configurePhase = ''
    runHook preConfigure

    export HOME=$(mktemp -d)
    yarn config --offline set yarn-offline-mirror ${finalAttrs.offlineCache}
    fixup-yarn-lock yarn.lock

    # set nodedir to prevent node-gyp from downloading headers
    # taken from https://nixos.org/manual/nixpkgs/stable/#javascript-tool-specific
    mkdir -p $HOME/.node-gyp/${nodejs.version}
    echo 9 > $HOME/.node-gyp/${nodejs.version}/installVersion
    ln -sfv ${nodejs}/include $HOME/.node-gyp/${nodejs.version}
    export npm_config_nodedir=${nodejs}

    yarn --offline --frozen-lockfile install --ignore-scripts --no-progress --non-interactive

    patchShebangs node_modules

    substituteInPlace node_modules/node-gyp/gyp/pylib/gyp/input.py \
      --replace-fail "from distutils.version import StrictVersion" "from packaging.version import Version as StrictVersion"

    ./node_modules/.bin/electron-rebuild -f

    substituteInPlace package.json \
      --replace-fail "electron-rebuild -f" "echo 0" \
      --replace-fail "&& yarn run lint:fix" ""

    mkdir -p node_modules/vscode-ripgrep/bin

    yarn --offline --frozen-lockfile install --no-progress
    patchShebangs node_modules

    substituteInPlace node_modules/node-gyp/gyp/pylib/gyp/input.py \
      --replace-fail "from distutils.version import StrictVersion" "from packaging.version import Version as StrictVersion"

    sed -i -e 's|path.join(.*);|"${lib.getExe ripgrep}";|' \
      node_modules/vscode-ripgrep/lib/index.js

    runHook postConfigure
  '';

  yarnBuildScript = "electron-builder";

  yarnBuildFlags = [
    "--dir"
    "-c.electronDist=${electron.dist}"
    "-c.electronVersion=${electron.version}"
  ];

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
  };

  preBuild = ''
    node .electron-vue/build.js
  ''; # From package.json

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/marktext $out/bin

    install -Dm644 resources/linux/marktext.desktop $out/share/applications/marktext.desktop

    pushd resources/icons/

    find -maxdepth 1 -mindepth 1 -type d -exec install -DT {}/marktext.png $out/share/icons/hicolor/{}/apps/marktext.png \;

    find -maxdepth 1 -mindepth 1 -type d -exec install -DT {}/md.png $out/share/icons/hicolor/{}/apps/md.png \;

    popd

    cp -r build/*-unpacked/{locales,resources{,.pak}} $out/opt/marktext

    makeWrapper ${lib.getExe electron} $out/bin/marktext \
      --add-flags $out/opt/marktext/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater {
    tagPrefix = "v";
    branch = "develop";
  };

  meta = {
    description = "Simple and elegant markdown editor, available for Linux, macOS and Windows";
    homepage = "https://www.marktext.cc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      nh2
      eduarrrd
      bot-wxt1221
    ];
    badPlatforms = [
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    platforms = lib.platforms.unix;
    mainProgram = "marktext";
  };
})
