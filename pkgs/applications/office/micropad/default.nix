{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnBuildHook,
  fetchzip,
  makeWrapper,
  makeDesktopItem,
  electron,
  desktopToDarwinBundle,
  copyDesktopItems,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "micropad";
  version = "4.5.1";

  src = fetchFromGitHub {
    owner = "MicroPad";
    repo = "Micropad-Electron";
    rev = "v${finalAttrs.version}";
    hash = "sha256-z+g+FwmoX4Qqf+v4BVLCtfrXwGiAUFlPLQQhp2CMhLU=";
  };

  # This project can't be built from source currently, because Nixpkgs lacks
  # ecosystem for https://bun.sh
  micropad-core = fetchzip {
    url = "https://github.com/MicroPad/MicroPad-Core/releases/download/v${finalAttrs.version}/micropad.tar.xz";
    hash = "sha256-y13PVA/AKKsc5q7NDwZFasb7fOo+56IW8qbTbsm2WWc=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-ESYSHuHLNsn3EYKIe2p0kg142jyC0USB+Ef//oGeF08=";
  };

  nativeBuildInputs = [
    yarnBuildHook
    copyDesktopItems
    makeWrapper
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ desktopToDarwinBundle ];

  installPhase = ''
    runHook preInstall

    # resources
    mkdir -p "$out/share/"
    cp -r './deps/micropad' "$out/share/micropad"
    ln -s '${finalAttrs.micropad-core}' "$out/share/micropad/core"
    rm "$out/share/micropad/node_modules"
    cp -r './node_modules' "$out/share/micropad"

    # icons
    for icon in $out/share/micropad/build/icons/*.png; do
      mkdir -p "$out/share/icons/hicolor/$(basename $icon .png | sed -e 's/^icon-//')/apps"
      ln -s "$icon" "$out/share/icons/hicolor/$(basename $icon .png | sed -e 's/^icon-//')/apps/micropad.png"
    done

    # executable wrapper
    makeWrapper '${electron}/bin/electron' "$out/bin/micropad" \
      --add-flags "$out/share/micropad" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"

    runHook postInstall
  '';

  # Do not attempt generating a tarball for micropad again.
  doDist = false;

  # The desktop item properties should be kept in sync with data from upstream:
  # https://github.com/MicroPad/MicroPad-Electron/blob/master/package.json
  desktopItems = [
    (makeDesktopItem {
      name = "micropad";
      exec = "micropad %u";
      icon = "micropad";
      desktopName = "µPad";
      startupWMClass = "µPad";
      comment = finalAttrs.meta.description;
      categories = [ "Office" ];
    })
  ];

  meta = {
    description = "A powerful note-taking app that helps you organise + take notes without restrictions";
    homepage = "https://getmicropad.com/";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ rhysmdnz ];
    inherit (electron.meta) platforms;
    mainProgram = "micropad";
  };
})
