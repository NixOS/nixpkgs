{
  lib,
  stdenv,
  copyDesktopItems,
  buildNpmPackage,
  electron_35,
  fetchFromGitLab,
  makeBinaryWrapper,
  makeDesktopItem,
  at-spi2-atk,
  gtk3,
  libappindicator-gtk3,
  libnotify,
  libsecret,
  libuuid,
  nss,
  xdg-utils,
  xorg,
}:
let
  version = "2.250507.0";
  electron = electron_35;
in
buildNpmPackage (finalAttrs: {
  pname = "gridtracker2";
  inherit version;

  src = fetchFromGitLab {
    owner = "gridtracker.org";
    repo = "gridtracker2";
    tag = "v${version}";
    hash = "sha256-8JFEVGy3Wz94FUK8V+JF+HHKBngT3VvwDBh+O2Bin6E=";
  };

  npmDepsHash = "sha256-ioocL1/k3aDmgVwxS09PFbMmteNrGncQz2yz7HUPX90=";

  nativeBuildInputs = [
    makeBinaryWrapper
    copyDesktopItems
  ];

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = true;

  makeCacheWritable = true;

  desktopItems = [
    (makeDesktopItem {
      name = "GridTracker2";
      desktopName = "GridTracker2";
      exec = "gridtracker2 %U";
      terminal = false;
      type = "Application";
      icon = "gridtracker2";
      startupWMClass = "GridTracker2";
      comment = "A warehouse of amateur radio information";
      categories = [
        "HamRadio"
        "Network"
      ];
    })
  ];

  postPatch = ''
    install -Dvm644 ${./package-lock.json} package-lock.json
  '';

  buildPhase =
    ''
      runHook preBuild
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      # electronDist needs to be modifiable on Darwin
      cp -r ${electron.dist} electron-dist
      chmod -R u+w electron-dist

      # Disable code signing during build on macOS.
      # https://github.com/electron-userland/electron-builder/blob/fa6fc16/docs/code-signing.md#how-to-disable-code-signing-during-the-build-process-on-macos
      export CSC_IDENTITY_AUTO_DISCOVERY=false

      npm exec electron-builder -- \
        --dir \
        -c.electronDist=electron-dist \
        -c.electronVersion=${electron.version}
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      npm exec electron-builder -- \
        --dir \
        -c.electronDist=${electron.dist} \
        -c.electronVersion=${electron.version}
    ''
    + ''
      runHook postBuild
    '';

  runtimeInputs =
    [
      at-spi2-atk
      gtk3
      libnotify
      libsecret
      libuuid
      nss
      xdg-utils
      xorg.libXScrnSaver
      xorg.libXtst
    ]
    ++ lib.optionals stdenv.isLinux [
      libappindicator-gtk3
    ];

  installPhase =
    ''
      runHook preInstall

    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      install -Dvm644 -t "$out/share/gridtracker2/resources" \
       ./dist/linux*/resources/*
      install -Dvm644 -t "$out/share/gridtracker2/locales" \
        ./dist/linux*/locales/*
      install -Dvm644 ./resources/icon.png \
        "$out/share/pixmaps/gridtracker2.png"

      makeWrapper ${lib.getExe electron} $out/bin/gridtracker2 \
        --add-flags $out/share/gridtracker2/resources/app.asar \
        --prefix PATH : "${lib.makeBinPath finalAttrs.runtimeInputs}" \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath finalAttrs.runtimeInputs}" \
        --add-flags "--no-sandbox --disable-gpu-sandbox" \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
        --inherit-argv0
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p $out/Applications $out/bin
      cp -r dist/mac*/GridTracker2.app $out/Applications
      ln -s $out/Applications/GridTracker2.app/Contents/MacOS/GridTracker2 $out/bin/gridtracker2
    ''
    + ''
      runHook postInstall
    '';

  meta = {
    description = "Warehouse of amateur radio information";
    homepage = "https://gridtracker.org/";
    license = lib.licenses.bsd3;
    platforms = electron.meta.platforms;
    maintainers = with lib.maintainers; [ Cryolitia ];
    mainProgram = "gridtracker2";
  };
})
