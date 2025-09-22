{
  buildNpmPackage,
  copyDesktopItems,
  electron,
  fetchFromGitHub,
  lib,
  makeDesktopItem,
  nix-update-script,
  npm-lockfile-fix,
  prefetch-npm-deps,
  rsync,
  stdenv,
}:

buildNpmPackage rec {
  pname = "super-productivity";
  version = "15.0.0";

  src = fetchFromGitHub {
    owner = "johannesjo";
    repo = "super-productivity";
    tag = "v${version}";
    hash = "sha256-Wik0u5NXWhQUWQar9yV4DkAIYZHOaC7FlhAM+YXWFBA=";

    postFetch = ''
      find $out -name package-lock.json -exec ${lib.getExe npm-lockfile-fix} -r {} \;
    '';
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

      # Some lockfiles do not include any dependencies to install so
      # prefertch-npm-deps produces an error.  Those can be ignored with
      # this flag.
      env.FORCE_EMPTY_CACHE = true;

      buildPhase = ''
        mkdir -p $out
        find -name package-lock.json | while read -r lockfile; do
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
      hash = "sha256-+lpK8SnXvk33hc/Pmv5g88/gQAT5tHgNDOCetOLgmnU=";
    }
  );

  makeCacheWritable = true;

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    CHROMEDRIVER_SKIP_DOWNLOAD = "true";
    CSC_IDENTITY_AUTO_DISCOVERY = "false";
  };

  nativeBuildInputs = [ copyDesktopItems ];

  postPatch = ''
    substituteInPlace electron-builder.yaml \
      --replace-fail "notarize: true" "notarize: false"
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
      -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ${
      if stdenv.hostPlatform.isDarwin then
        ''
          mkdir -p $out/Applications
          cp -r ".tmp/app-builds/mac"*"/Super Productivity.app" "$out/Applications"
          makeWrapper "$out/Applications/Super Productivity.app/Contents/MacOS/Super Productivity" "$out/bin/super-productivity"
        ''
      else
        ''
          mkdir -p $out/share/{super-productivity,icons/hicolor/scalable/apps}
          cp -r .tmp/app-builds/*-unpacked/resources/app.asar $out/share/super-productivity
          cp electron/assets/icons/ico-circled.svg $out/share/icons/hicolor/scalable/apps/super-productivity.svg

          makeWrapper '${lib.getExe electron}' "$out/bin/super-productivity" \
            --add-flags "$out/share/super-productivity/app.asar" \
            --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
            --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
            --inherit-argv0
        ''
    }

    runHook postInstall
  '';

  # copied from deb file
  desktopItems = [
    (makeDesktopItem {
      name = "super-productivity";
      desktopName = "superProductivity";
      exec = "super-productivity %u";
      terminal = false;
      type = "Application";
      icon = "super-productivity";
      startupWMClass = "superProductivity";
      comment = "ToDo list and Time Tracking";
      categories = [
        "Office"
        "ProjectManagement"
      ];
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
      offline
      pineapplehunter
    ];
    mainProgram = "super-productivity";
  };
}
