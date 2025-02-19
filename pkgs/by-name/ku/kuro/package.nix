{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  nodejs,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  electron,
}:

stdenv.mkDerivation rec {
  pname = "kuro";
  version = "9.0.0";

  src = fetchFromGitHub {
    owner = "davidsmorais";
    repo = "kuro";
    rev = "v${version}";
    hash = "sha256-9Z/r5T5ZI5aBghHmwiJcft/x/wTRzDlbIupujN2RFfU=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-GTiNv7u1QK/wjQgpka7REuoLn2wjZG59kYJQaZZPycI=";
  };

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    nodejs
    makeWrapper
    copyDesktopItems
  ];

  yarnBuildScript = "electron-builder";
  yarnBuildFlags = [
    "--dir"
    "-c.electronDist=${electron.dist}"
    "-c.electronVersion=${electron.version}"
  ];

  installPhase = ''
    runHook preInstall

    # resources
    mkdir -p "$out/share/lib/kuro"
    cp -r ./dist/*-unpacked/{locales,resources{,.pak}} "$out/share/lib/kuro"

    # icons
    install -Dm644 ./static/Icon.png $out/share/icons/hicolor/1024x1024/apps/kuro.png

    # executable wrapper
    makeWrapper '${electron}/bin/electron' "$out/bin/kuro" \
      --add-flags "$out/share/lib/kuro/resources/app.asar" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --inherit-argv0

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "kuro";
      exec = "kuro";
      icon = "kuro";
      desktopName = "Kuro";
      genericName = "Microsoft To-Do Client";
      comment = meta.description;
      categories = [ "Office" ];
      startupWMClass = "kuro";
    })
  ];

  meta = with lib; {
    changelog = "https://github.com/davidsmorais/kuro/releases/tag/${src.rev}";
    description = "An unofficial, featureful, open source, community-driven, free Microsoft To-Do app";
    homepage = "https://github.com/davidsmorais/kuro";
    license = licenses.mit;
    mainProgram = "kuro";
    maintainers = with maintainers; [ ChaosAttractor ];
    inherit (electron.meta) platforms;
  };
}
