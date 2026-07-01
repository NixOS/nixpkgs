{
  buildNpmPackage,
  copyDesktopItems,
  electron_41,
  fetchFromGitHub,
  lib,
  makeDesktopItem,
  nix-update-script,
  prefetch-npm-deps,
  rsync,
  stdenv,
  nodejs_22,
  rustPlatform,
  cacert,
  cargo,
}:
let
  electron = electron_41;
  nodejs = nodejs_22;
in
buildNpmPackage rec {
  pname = "super-productivity";
  version = "18.12.1";

  inherit nodejs;

  src = fetchFromGitHub {
    owner = "johannesjo";
    repo = "super-productivity";
    tag = "v${version}";
    hash = "sha256-19wMmVKHnnSUsu2xOplNY3HeDhoOdFgX05I5XKTwRhM=";
  };

  # Use custom fetcher for deps because super-productivity uses multiple
  # package-lock.json files to manage plugins.  It checks all lock
  # files and produces a merged output.  This should still be compatible
  # with nix-update.
  npmDeps = stdenv.mkDerivation (
    lib.fetchers.normalizeHash { } {
      pname = "super-productivity-deps";
      inherit version src;

      nativeBuildInputs = [
        prefetch-npm-deps
        rsync
      ];

      __structuredAttrs = true;
      strictDeps = true;

      env = {
        # Some lockfiles do not include any dependencies to install so
        # prefertch-npm-deps produces an error.  Those can be ignored with
        # this flag.
        FORCE_EMPTY_CACHE = true;
        NPM_FETCHER_VERSION = "2";
        SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
      };

      buildPhase = ''
        mkdir -p $out
        find -name package-lock.json | sort | while read -r lockfile; do
          prefetch-npm-deps $lockfile /tmp/cache
          # Merge output
          rsync -a /tmp/cache/ $out
          rm -rf /tmp/cache
        done
        # Ensure that the root package-lock.json is placed in the output.
        # This means only the root lockfile is checked for consistancy,
        # but that should not be an issue.
        cp package-lock.json $out
      '';

      dontInstall = true;

      outputHashMode = "recursive";
      hash = "sha256-MBlILswZWTpfjHxazTyH72vYUrJ/9ZD3Kdcix/yFNJ0=";
    }
  );

  makeCacheWritable = true;
  npmDepsFetcherVersion = 2;

  cargoRoot = "electron/wayland-idle-helper";
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit
      pname
      version
      src
      cargoRoot
      ;
    hash = "sha256-u/GjzX8zykIqJlMR/611ADX2EcD1cb4Qr94EkI2sdlA=";
  };

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    CHROMEDRIVER_SKIP_DOWNLOAD = "true";
  };

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    cargo
    copyDesktopItems
    rustPlatform.cargoSetupHook
  ];

  postPatch = ''
    substituteInPlace electron-builder.yaml \
      --replace-fail "notarize: true" "notarize: false"

    # At runtime the helper is looked up via app.getAppPath() (the dirname of
    # the asar file).  process.execPath points to the system electron binary,
    # not our app directory, so it would search the wrong location.
    substituteInPlace electron/idle-time-handler.ts \
      --replace-fail "path.dirname(process.execPath)" "path.dirname(app.getAppPath())"
  '';

  buildPhase = ''
    runHook preBuild

    # Npm hooks do not install packages for the plugins. The build
    # script does install the packages, but it does not handle patching
    # the shebangs.
    find packages -name package-lock.json | while read -r p; do
      npm --prefix "$(dirname $p)" ci --ignore-scripts
    done
    patchShebangs packages

    # electronDist needs to be modifiable on Darwin
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    npm run prepare
    npm run build
    npm exec electron-builder -- --dir \
      -c.electronDist=electron-dist \
      -c.electronVersion=${electron.version} \
      -c.mac.identity=null

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ${
      if stdenv.hostPlatform.isDarwin then
        ''
          mkdir -p $out/Applications
          cp -r ".tmp/app-builds/mac"*"/Super Productivity.app" "$out/Applications"
          makeWrapper "$out/Applications/Super Productivity.app/Contents/MacOS/Super Productivity" "$out/bin/superproductivity"
        ''
      else
        ''
          mkdir -p $out/share/{superproductivity,icons/hicolor/scalable/apps}
          cp -r .tmp/app-builds/*-unpacked/{resources/app.asar,wayland-idle-helper} $out/share/superproductivity
          cp electron/assets/icons/ico-circled.svg $out/share/icons/hicolor/scalable/apps/superproductivity.svg
          makeWrapper '${lib.getExe electron}' "$out/bin/superproductivity" \
            --add-flags "$out/share/superproductivity/app.asar" \
            --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
            --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
            --inherit-argv0
        ''
    }

    # backward compat symlink for the old binary name
    ln -s superproductivity "$out"/bin/super-productivity

    runHook postInstall
  '';

  # matches upstream electron-builder.yaml linux.desktop config
  desktopItems = [
    (makeDesktopItem {
      name = "superproductivity";
      desktopName = "Super Productivity";
      exec = "superproductivity %U";
      terminal = false;
      type = "Application";
      icon = "superproductivity";
      startupWMClass = "superproductivity";
      categories = [
        "Office"
        "ProjectManagement"
      ];
      mimeTypes = [ "x-scheme-handler/superproductivity" ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "To Do List / Time Tracker with Jira Integration";
    longDescription = ''
      Experience the best ToDo app for digital professionals and get more done!
      Super Productivity comes with integrated time-boxing and time tracking capabilities
      and you can load your task from your calendars and from
      Jira, Gitlab, GitHub, Open Project and others all into a single ToDo list.
    '';
    homepage = "https://super-productivity.com";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      pineapplehunter
      tebriel
    ];
    mainProgram = "superproductivity";
  };
}
