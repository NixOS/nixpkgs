{
  lib,
  fetchFromGitHub,
  makeDesktopItem,
  copyDesktopItems,
  stdenv,
  makeWrapper,
  replaceVars,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  nodejs,
  electron,
  jq,
  python3,
  cmake,
  xcodebuild,
  cctools,
  darwin,
}:

let
  pnpm = pnpm_10;

  libsession-util-nodejs = stdenv.mkDerivation (finalAttrs: {
    pname = "libsession-util-nodejs";
    version = "0.7.5"; # find version in pnpm-lock.yaml
    src = fetchFromGitHub {
      owner = "session-foundation";
      repo = "libsession-util-nodejs";
      tag = "v${finalAttrs.version}";
      fetchSubmodules = true;
      hash = "sha256-jM070usyclJp59E/AIRu7IYGjIEFPJXCcL9SeYPwLgI=";
    };

    patches = [
      # On darwin `libcxxhardeningfast` turns dereferencing an std::optional without checking its value into a SIGTRAP
      # This results in the app crashing when trying to send a message.
      # https://github.com/NixOS/nixpkgs/blob/b1d9a62b561edeb70393d75fdcb7978f07e4ae61/doc/stdenv/stdenv.chapter.md#libcxxhardeningfast-libcxxhardeningfast
      ./libsession-darwin-crash.patch
    ];

    env.LIBSESSION_RUNTIME_VERSION = electron.version;

    nativeBuildInputs = [
      pnpmConfigHook
      pnpm
      nodejs
      cmake
      python3
    ];

    dontUseCmakeConfigure = true;

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      inherit pnpm;
      fetcherVersion = 4;
      hash = "sha256-e5gB/8P/OrgfR4T/xwE2QdUCu+A2sC34qrJoCuPdgdY=";
    };

    preBuild = ''
      # prevent downloading; see https://github.com/cmake-js/cmake-js/blob/v7.3.1/lib/dist.js
      mkdir -p "$HOME/.cmake-js/electron-${stdenv.hostPlatform.node.arch}"
      ln -s ${electron.headers} "$HOME/.cmake-js/electron-${stdenv.hostPlatform.node.arch}/v${electron.version}"
    '';

    # The install script is the build script.
    buildPhase = ''
      runHook preBuild

      pnpm run install

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/build/Release
      cp -r package.json index.js index.d.ts types $out
      cp build/Release/libsession_util_nodejs.node $out/build/Release

      runHook postInstall
    '';

    meta = {
      homepage = "https://github.com/session-foundation/libsession-util-nodejs";
      # No license file, but gpl3Only makes sense because package.json says GPL-3.0,
      # which is also consistent with session-desktop and libsession-util.
      license = lib.licenses.gpl3Only;
    };
  });

in
stdenv.mkDerivation (finalAttrs: {
  pname = "session-desktop";
  version = "1.18.3";
  src = fetchFromGitHub {
    owner = "session-foundation";
    repo = "session-desktop";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-yhiQaqpuglaIoEwJeq4tgyVj5Cz+8xxhMaAmSxI+xdA=";
  };

  # This upstream release's lockfile lacks integrity fields required by pnpm >= 10.34.1.
  # Remove this packaging patch when updating to a source lockfile that includes them.
  patches = [ ./add-pnpm-tarball-integrities.patch ];

  postPatch = ''
    # too restrictive Node version requirement
    jq 'del(.engines)' package.json > package.json.new
    mv package.json.new package.json
  '';

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
    pnpmConfigHook
    pnpm
    nodejs
    jq
    python3
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    cctools # provides libtool needed for better-sqlite3
    xcodebuild
    darwin.autoSignDarwinBinariesHook
  ];

  env = {
    npm_config_nodedir = electron.headers;
    ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
  };

  dontUseCmakeConfigure = true;
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      patches
      pname
      src
      version
      ;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-lzuQCWsWYWNmGg+9xPrORbC06ECk7haGHbjlFeUb6Bo=";
  };

  buildPhase = ''
    runHook preBuild

    export NODE_ENV=production

    # rebuild native modules except libsession_util_nodejs
    libsession_util_nodejs_path=$(readlink -f node_modules/libsession_util_nodejs)
    rm -r $libsession_util_nodejs_path
    pnpm rebuild --verbose
    rm -rf $libsession_util_nodejs_path
    cp -r --no-preserve=mode ${libsession-util-nodejs} $libsession_util_nodejs_path

    # some important things that did not run because of --ignore-scripts
    pnpm run postinstall

    pnpm run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    CI=true pnpm prune --prod --ignore-scripts
    rm -rf app/node_modules

    phome=$out/lib/node_modules/session-desktop
    mkdir -p $(dirname $phome)
    cp -r app $phome
    cp -r node_modules $phome
    cp package.json $phome

    makeWrapper ${lib.getExe electron} $out/bin/session-desktop \
      --add-flags $phome \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --set NODE_ENV production \
      --suffix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ stdenv.cc.cc ]}" \
      --inherit-argv0

    for f in build/icons/icon_*.png; do
      base=$(basename $f .png)
      size=''${base#icon_}
      install -Dm644 $f $out/share/icons/hicolor/$size/apps/session-desktop.png
    done

    runHook postInstall
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications/Session.app/Contents/{MacOS,Resources}
    ln -s $out/bin/session-desktop $out/Applications/Session.app/Contents/MacOS/Session
    install -Dm644 build/icon-mac.icns $out/Applications/Session.app/Contents/Resources/icon.icns
    install -Dm644 ${
      # Adapted from the dmg package from upstream:
      # https://github.com/session-foundation/session-desktop/releases/download/v1.16.10/session-desktop-mac-arm64-1.16.10.dmg
      replaceVars ./Info.plist { inherit (finalAttrs) version; }
    } $out/Applications/Session.app/Contents/Info.plist
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "Session";
      desktopName = "Session";
      comment = "Onion routing based messenger";
      exec = "session-desktop";
      icon = "session-desktop";
      terminal = false;
      type = "Application";
      categories = [ "Network" ];
    })
  ];

  passthru = {
    inherit libsession-util-nodejs;
    updateScript = ./update.sh;
  };

  meta = {
    description = "Onion routing based messenger";
    mainProgram = "session-desktop";
    homepage = "https://getsession.org/";
    downloadPage = "https://getsession.org/download";
    changelog = "https://github.com/session-foundation/session-desktop/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      alexnortung
      ulysseszhan
    ];
    platforms = lib.platforms.all;
  };
})
