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
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  yarnInstallHook,
  rustPlatform,
  nodejs,
  electron,
  jq,
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

  sqlcipher-src = stdenv.mkDerivation (finalAttrs: {
    pname = "sqlcipher-src";
    # when updating: look for the version in deps/download.js of @signalapp/better-sqlite3, whose version is in turn found in yarn.lock
    version = "4.6.1";
    src = fetchFromGitHub {
      owner = "signalapp";
      repo = "sqlcipher";
      tag = "v${finalAttrs.version}-f_barrierfsync";
      hash = "sha256-3fGRPZpJmLbY95DLJ34BK53ZTzJ1dWEzislXsOrTc8k=";
    };

    patches = [
      # Needed to reproduce the build artifact from Signal's CI.
      # TODO: find the actual CI workflow that produces
      # https://build-artifacts.signal.org/desktop/sqlcipher-v2-4.6.1-signal-patch2--0.2.1-asm2-6253f886c40e49bf892d5cdc92b2eb200b12cd8d80c48ce5b05967cfd01ee8c7.tar.gz
      # See also: https://github.com/signalapp/better-sqlite3/blob/v9.0.13/deps/defines.gypi#L33
      # Building @signalapp/better-sqlite3 will require openssl without this patch.
      (fetchpatch {
        name = "sqlcipher-crypto-custom.patch";
        url = "https://github.com/sqlcipher/sqlcipher/commit/702af1ff87528a78f5a9b2091806d3a5642e1d4a.patch";
        hash = "sha256-OKh6qCGHBQWZyzXfyEveAs71wrNwlWLuG9jNqDeKNG4=";
      })
    ];

    buildInputs = [
      openssl
      tcl
    ];

    # see https://github.com/signalapp/node-sqlcipher/blob/v2.4.4/deps/sqlcipher/update.sh
    configureFlags = [ "--enable-update-limit" ];
    makeFlags = [
      "sqlite3.h"
      "sqlite3.c"
      "sqlite3ext.h"
      "shell.c"
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp sqlite3.h sqlite3.c sqlite3ext.h shell.c $out

      runHook postInstall
    '';

    meta = {
      homepage = "https://github.com/signalapp/sqlcipher";
      license = lib.licenses.bsd3;
    };
  });

  signal-sqlcipher-extension = rustPlatform.buildRustPackage (finalAttrs: {
    pname = "signal-sqlcipher-extension";
    # when updating: look for the version in deps/download.js of @signalapp/better-sqlite3, whose version is in turn found in yarn.lock
    version = "0.2.1";
    src = fetchFromGitHub {
      owner = "signalapp";
      repo = "Signal-Sqlcipher-Extension";
      rev = "v${finalAttrs.version}";
      hash = "sha256-INSkm7ZuetPASuIqezzzG/bXoEHClUb9XpxWbxLVXRc=";
    };

    cargoHash = "sha256-qT4HM/FRL8qugKKNlMYM/0zgUsC6cDOa9fgd1d4VIrc=";

    postInstall = ''
      mkdir -p $out/include
      cp target/*.h $out/include
    '';

    meta = {
      homepage = "https://github.com/signalapp/Signal-Sqlcipher-Extension";
      license = lib.licenses.agpl3Only;
    };
  });

  libsession-util-nodejs = stdenv.mkDerivation (finalAttrs: {
    pname = "libsession-util-nodejs";
    version = "0.5.5"; # find version in yarn.lock
    src = fetchFromGitHub {
      owner = "session-foundation";
      repo = "libsession-util-nodejs";
      tag = "v${finalAttrs.version}";
      fetchSubmodules = true;
      deepClone = true; # need git rev for all submodules
      hash = "sha256-FmI9Xmml+sjXHJ+W6CfBC8QUrQR89H3HWEYlHE2Xsts=";
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
      yarnConfigHook
      yarnBuildHook
      yarnInstallHook
      nodejs
      cmake
      python3
      fake-git # used in update_version.sh, libsession-util/external/oxen-libquic/cmake/check_submodule.cmake, etc.
      jq
    ];

    dontUseCmakeConfigure = true;
    yarnOfflineCache = fetchYarnDeps {
      yarnLock = "${finalAttrs.src}/yarn.lock";
      hash = "sha256-0pH88EOqxG/kg7edaWnaLEs3iqhIoRCJxDdBn4JxYeY=";
    };

    preBuild = ''
      # prevent downloading; see https://github.com/cmake-js/cmake-js/blob/v7.3.1/lib/dist.js
      mkdir -p "$HOME/.cmake-js/electron-${stdenv.hostPlatform.node.arch}"
      ln -s ${electron.headers} "$HOME/.cmake-js/electron-${stdenv.hostPlatform.node.arch}/v${electron.version}"

      # populate src/version.h
      yarn update_version
    '';

    # The install script is the build script.
    # `yarn install` may be better than `yarn run install`.
    # However, the former seems to use /bin/bash while the latter uses stdenv.shell,
    # and the former simply cannot find the cmake-js command, which is pretty weird,
    # and using `yarn config set script-shell` does not help.
    yarnBuildScript = "run";
    yarnBuildFlags = "install";

    postInstall = ''
      # build is not installed by default because it is in .gitignore
      cp -r build $out/lib/node_modules/libsession_util_nodejs
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
  version = "1.16.10";
  src = fetchFromGitHub {
    owner = "session-foundation";
    repo = "session-desktop";
    tag = "v${finalAttrs.version}";
    leaveDotGit = true;
    hash = "sha256-9l5AgG9YNz61lS/1Q/b46UgdyidHH7sQK7ZWz19XWr0=";
    postFetch = ''
      pushd $out
      git rev-parse HEAD > .gitrev
      rm -rf .git
      popd
    '';
  };

  postPatch = ''
    jq '
      del(.engines) # too restrictive Node version requirement
      # control what files are packed in the install phase
      + {files: ["**/*.js", "**/*.html", "**/*.node", "_locales", "config", "fonts", "images", "mmdb", "mnemonic_languages", "protos", "sound", "stylesheets"]}
    ' package.json > package.json.new
    mv package.json.new package.json
  '';

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
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
  yarnOfflineCache = fetchYarnDeps {
    # Future maintainers: keep in mind that sometimes the upstream deduplicates dependencies
    # (see the `dedup` script in package.json) before committing yarn.lock,
    # which may unfortunately break the offline cache (and may not).
    # If that happens, clone the repo and run `yarn install --ignore-scripts` yourself,
    # copy the modified yarn.lock here, and use `./yarn.lock` instead of `"${finalAttrs.src}/yarn.lock"`,
    # and also add `cp ${./yarn.lock} yarn.lock` to postPatch.
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-A2AbKOXWx8+PN467DVpKVTorZDs/UFaxjc7VS0Xdo6k=";
  };

  preBuild = ''
    # prevent downloading
    pushd node_modules/@signalapp/better-sqlite3/deps
    tar -czf sqlcipher.tar.gz \
      -C ${signal-sqlcipher-extension} lib include \
      -C ${sqlcipher-src} . \
      --transform="s,^lib,./signal-sqlcipher-extension/${stdenv.targetPlatform.rust.cargoShortTarget}," \
      --transform="s,^include,./signal-sqlcipher-extension/include,"
    hash=$(sha256sum sqlcipher.tar.gz | cut -d' ' -f1)
    sed -i "s/^const HASH = '.*';/const HASH = '$hash';/" download.js
    popd

    export NODE_ENV=production

    # rebuild native modules except libsession_util_nodejs
    rm -rf node_modules/libsession_util_nodejs
    npm rebuild --verbose --offline --no-progress --release # why doesn't yarn have `rebuild`?
    cp -r ${libsession-util-nodejs}/lib/node_modules/libsession_util_nodejs node_modules
    chmod -R +w node_modules/libsession_util_nodejs
    rm -rf node_modules/libsession_util_nodejs/node_modules

    # some important things that did not run because of --ignore-scripts
    yarn run postinstall
  '';

  preInstall = ''
    # Do not want yarn prune to remove native modules that we just built.
    mv node_modules node_modules.dev
  '';

  postInstall = ''
    find node_modules.dev -mindepth 2 -maxdepth 3 -type d -name build  | while read -r buildDir; do
      packageDir=$(dirname ''${buildDir#node_modules.dev/})
      installPackageDir="$out/lib/node_modules/session-desktop/node_modules/$packageDir"
      if [ -d "$installPackageDir" ]; then
        cp -r "$buildDir" "$installPackageDir"
      fi
    done

    makeWrapper ${lib.getExe electron} $out/bin/session-desktop \
      --add-flags $out/lib/node_modules/session-desktop \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --set NODE_ENV production \
      --inherit-argv0

    for f in build/icons/icon_*.png; do
      base=$(basename $f .png)
      size=''${base#icon_}
      install -Dm644 $f $out/share/icons/hicolor/$size/apps/session-desktop.png
    done
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
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
    inherit sqlcipher-src signal-sqlcipher-extension libsession-util-nodejs;
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
