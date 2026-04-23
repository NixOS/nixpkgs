{
  lib,
  stdenv,
  fetchzip,
  fetchYarnDeps,
  yarn,
  fixup-yarn-lock,
  yarnConfigHook,
  nodejs_22,
  electron,
  frama-c,
  makeWrapper,
  makeDesktopItem,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ivette";
  version = "32.1";
  slang = "Germanium";

  __structuredAttrs = true;

  # Not fetchurl, because we need it unzipped before fetchYarnDeps
  src = fetchzip {
    url = "https://frama-c.com/download/frama-c-${finalAttrs.version}-${finalAttrs.slang}.tar.gz";
    hash = "sha256-D+OJy/pcOqSSexqHVsyCSLSHcMg8zbjKDfmqBZ8xvbk=";
  };

  sourceRoot = "${finalAttrs.src.name}/ivette";

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/ivette/yarn.lock";
    hash = "sha256-1NRSTJkXZ1jvkB/7xI0+u4PmrEzKc3VVBdwM50PtznI=";
  };

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  strictDeps = true;

  nativeBuildInputs = [
    yarnConfigHook
    nodejs_22
    yarn
    makeWrapper
  ];

  postPatch = ''
    substituteInPlace src/frama-c/server.ts \
      --replace-fail "command = 'frama-c'" \
      "command = '${lib.getExe frama-c}'"
  '';

  buildPhase = ''
    runHook preBuild

    # From api.sh
    ${lib.getExe frama-c} -server-tsc -server-tsc-out src

    # Run configure.js and sandboxer.js
    make pkg

    # From src/dome/template/makefile:103
    cp ./src/dome/template/react-virtualized.hacked.onScroll.js \
      ./node_modules/react-virtualized/dist/es/WindowScroller/utils/onScroll.js

    DOME=./src/dome DOME_ENV=app yarn --offline run build

    yarn --offline electron-builder --dir \
      -c.electronDist=${electron.dist} \
      -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/lib/ivette"
    cp -r dist/*-unpacked/{locales,resources{,.pak}} "$out/share/lib/ivette"

    install -Dm444 static/icon.png $out/share/icons/hicolor/512x512/apps/ivette.png

    makeWrapper '${electron}/bin/electron' "$out/bin/ivette" \
      --add-flags "$out/share/lib/ivette/resources/app.asar" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --add-flags "--no-sandbox" \
      --inherit-argv0

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "ivette";
      exec = "ivette";
      icon = "ivette";
      desktopName = "Ivette";
      genericName = "Frama-C's GUI";
      comment = finalAttrs.meta.description;
      categories = [ "Development" ];
      startupWMClass = "Ivette";
    })
  ];

  meta = {
    description = "Graphical User Interface for Frama-C";
    longDescription = ''
      Ivette is the Graphical User Interface (GUI) of Frama-C. It
      enables exploring code, augmented with several navigation tools
      and highlighting modes; it allows launching, parametrizing and
      visualizing analyses; and it allows combining them seamlessly,
      taking full advantage of the multi-paradigm approach.
    '';
    homepage = "https://www.frama-c.com/html/ivette.html";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [
      luc65r
    ];
    platforms = lib.platforms.unix;
    mainProgram = "ivette";
  };
})
