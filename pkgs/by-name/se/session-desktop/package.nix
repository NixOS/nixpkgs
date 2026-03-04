{
  lib,
  fetchFromGitHub,
  makeDesktopItem,
  writeShellScriptBin,
  copyDesktopItems,
  stdenv,
  makeWrapper,
  fetchpatch,
  replaceVars,
  pnpm,
  fetchPnpmDeps,
  pnpmConfigHook,
  rustPlatform,
  nodejs,
  electron,
  jq,
  tsx,
  python3,
  git,
  cmake,
  openssl,
  tcl,
  xcodebuild,
  cctools,
  darwin,
}:

let
  fake-git = writeShellScriptBin "git" (lib.readFile ./fake-git.sh);

  libsession-util-nodejs = stdenv.mkDerivation (finalAttrs: {
    pname = "libsession-util-nodejs";
    version = "0.6.12"; # find version in pnpm-lock.yaml
    src = fetchFromGitHub {
      owner = "session-foundation";
      repo = "libsession-util-nodejs";
      tag = "v${finalAttrs.version}";
      fetchSubmodules = true;
      deepClone = true; # need git rev for all submodules
      hash = "sha256-6+eAofi4uapRKqJvCrekP7MWTfdd4VhOnSbc/8rsFic=";
      # fetchgit is not reproducible with deepClone + fetchSubmodules:
      # https://github.com/NixOS/nixpkgs/issues/100498
      postFetch = ''
        find $out -name .git -type d -prune | while read -r gitdir; do
          pushd "$(dirname "$gitdir")"
          git rev-parse HEAD > .gitrev
          popd
        done
        find $out -name .git -type d -prune -exec rm -rf {} +
      '';
    };

    postPatch = ''
      sed -i -E 's/--runtime-version=[^[:space:]]*/--runtime-version=${electron.version}/' package.json
    '';

    nativeBuildInputs = [
      pnpmConfigHook
      pnpm
      nodejs
      cmake
      python3
      fake-git # used in update_version.sh, libsession-util/external/oxen-libquic/cmake/check_submodule.cmake, etc.
    ];

    dontUseCmakeConfigure = true;

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      inherit pnpm;
      fetcherVersion = 3;
      hash = "sha256-oadNQJsSmwR/ADWO6Zu+Ji3CwkwupmQFX8OfUgKDtEU=";
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

      mkdir -p $out/lib/node_modules
      cp -r . $out/lib/node_modules/libsession_util_nodejs
      # TODO: clean up unnecessary files

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
  version = "1.17.12";
  src =
    (fetchFromGitHub {
      owner = "session-foundation";
      repo = "session-desktop";
      tag = "v${finalAttrs.version}";
      fetchSubmodules = true;
      leaveDotGit = true;
      postFetch = ''
        pushd $out
        git rev-parse HEAD > .gitrev
        rm -rf .git
        popd
      '';
      hash = "sha256-+ZLTIBXXjqX1TAGboXU4OYQPBDXMm7epfY3tsi3zOfk=";
    }).overrideAttrs
      (oldAttrs: {
        # https://github.com/NixOS/nixpkgs/issues/195117#issuecomment-1410398050
        env = oldAttrs.env or { } // {
          GIT_CONFIG_COUNT = 1;
          GIT_CONFIG_KEY_0 = "url.https://github.com/.insteadOf";
          GIT_CONFIG_VALUE_0 = "git@github.com:";
        };
      });

  postPatch = ''
    # too restrictive Node version requirement
    jq 'del(.engines)' package.json > package.json.new
    mv package.json.new package.json

    # use tsx from nixpkgs instead of using pnpx to download it
    substituteInPlace package.json --replace-fail 'pnpx tsx' '${lib.getExe tsx}'
  '';

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
    pnpmConfigHook
    pnpm
    nodejs
    jq
    python3
    fake-git # see build/updateLocalConfig.js
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
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 3;
    hash = "sha256-rusUkqokhhmbqTgzIQIbqFCNbI1pmIxO5USy7mmOzxs=";
  };

  buildPhase = ''
    runHook preBuild

    export NODE_ENV=production

    # rebuild native modules except libsession_util_nodejs
    libsession_util_nodejs_path=$(readlink -f node_modules/libsession_util_nodejs)
    rm -r $libsession_util_nodejs_path
    pnpm rebuild --verbose
    rm -r $libsession_util_nodejs_path
    cp -r "${finalAttrs.passthru.libsession-util-nodejs}/lib/node_modules/libsession_util_nodejs" $libsession_util_nodejs_path
    chmod -R +w $libsession_util_nodejs_path
    rm -r $libsession_util_nodejs_path/node_modules

    # some important things that did not run because of --ignore-scripts
    pnpm run postinstall

    pnpm run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    phome=$out/lib/node_modules/session-desktop
    mkdir -p $(dirname $phome)
    cp -r app $phome
    cp -r node_modules $phome # TODO: exclude unnecessary files
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
