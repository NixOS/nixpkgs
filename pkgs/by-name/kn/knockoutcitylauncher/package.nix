{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  buildNpmPackage,
  copyDesktopItems,
  makeDesktopItem,
  makeWrapper,
  electron_43,
}:
let
  electron = electron_43;
  stdenv = stdenvNoCC;
in
buildNpmPackage (finalAttrs: {
  pname = "knockoutcitylauncher";
  version = "2.4.6";

  src = fetchFromGitHub {
    owner = "kocxyz";
    repo = "Launcher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-INwJ6j1KNm9ABETN0bwUijFS4stM2LQdjDMSMprwQTQ=";
  };

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  npmDepsHash = "sha256-nM0Oyifz+JKjnyd2Vpq2q7yF7OrTpBSi4alMlLWTrcI=";
  forceGitDeps = true;
  makeCacheWritable = true;
  __structuredAttrs = true;

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  patches = [
    ./updatecheck-and-devconsole.patch
  ];

  buildPhase = ''
    runHook preBuild

    npm exec electron-vite -- build

    # create the electron archive to be used by electron-packager
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    npm exec electron-builder -- \
      --dir \
      --linux \
      -c.electronDist=electron-dist \
      -c.electronVersion=${electron.version} \
      -p never

    rm -r electron-dist

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm444 "resources/icon.png" "$out/share/icons/hicolor/scalable/apps/knockoutcitylauncher.png"

    mkdir -p "$out/share/knockoutcitylauncher"
    rm -f "$out/share/knockoutcitylauncher/resources/default_app.asar"

    mkdir -p "$out/share/knockoutcitylauncher"
    cp -r dist/*-unpacked/resources{,.pak} "$out/share/knockoutcitylauncher"

    makeWrapper ${lib.getExe electron} "$out/bin/knockoutcitylauncher" \
      --add-flag $out/share/knockoutcitylauncher/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --inherit-argv0

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "Knockout City Launcher";
      exec = finalAttrs.meta.mainProgram;
      icon = finalAttrs.meta.mainProgram;
      desktopName = "Knockout City Launcher";
      genericName = "Game Launcher";
      categories = [
        "Network"
        "Game"
      ];
      startupWMClass = "knockoutcitylauncher";
    })
  ];

  meta = {
    description = "Unofficial Knockout City Launcher";
    homepage = "https://kocity.xyz/";
    downloadPage = "https://github.com/kocxyz/Launcher/releases";
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.liamthexpl0rer ];
    platforms = lib.platforms.linux;
    mainProgram = "knockoutcitylauncher";
  };
})
