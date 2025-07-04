{
  buildNpmPackage,
  copyDesktopItems,
  electron,
  fetchFromGitHub,
  lib,
  makeDesktopItem,
  nix-update-script,
  npm-lockfile-fix,
  stdenv,
}:

buildNpmPackage rec {
  pname = "super-productivity";
  version = "13.0.10";

  src = fetchFromGitHub {
    owner = "johannesjo";
    repo = "super-productivity";
    tag = "v${version}";
    hash = "sha256-2K/6T4f9tLlrKimT/DPSdoz8LHij5nsaF6BWSQf6u7U=";

    postFetch = ''
      ${lib.getExe npm-lockfile-fix} -r $out/package-lock.json
    '';
  };

  npmDepsHash = "sha256-l9P11ZvLYiTu/cVPQIw391ZTJ0K+cNPUzoVMsdze2uo=";
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
          cp -r "app-builds/mac"*"/Super Productivity.app" "$out/Applications"
          makeWrapper "$out/Applications/Super Productivity.app/Contents/MacOS/Super Productivity" "$out/bin/super-productivity"
        ''
      else
        ''
          mkdir -p $out/share/{super-productivity,icons/hicolor/scalable/apps}
          cp -r app-builds/*-unpacked/resources/app.asar $out/share/super-productivity
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
