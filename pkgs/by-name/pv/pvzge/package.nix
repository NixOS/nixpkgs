{
  lib,
  stdenvNoCC,
  fetchurl,
  fetchFromGitHub,
  copyDesktopItems,
  makeWrapper,
  makeDesktopItem,
  electron,
  imagemagick,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pvzge";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "Gzh0821";
    repo = "pvzge_web";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IZaJBbliudkVLOEgOwxXkUn9aET+NJrgdPi8FAA7HCE=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
    imagemagick
  ];

  postPatch = ''
    sed -i "s|<title>.*</title>|<title>PvZ2: Gardendless</title>|" docs/index.html
  '';

  dontConfigure = true;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    phome=$out/share/pvzge
    mkdir -p $(dirname $phome)
    cp -r docs $phome

    tee $phome/package.json <<JSON
    {
      "name": "pvzge",
      "version": "${finalAttrs.version}",
      "description": "${finalAttrs.meta.description}",
      "main": "main.js",
      "author": "Gaozih"
    }
    JSON
    # adapted from Electron tutorial: https://www.electronjs.org/docs/latest/tutorial/tutorial-first-app
    # some boilerplate code to get Electron running
    cp ${./main.js} $phome/main.js

    makeWrapper ${lib.getExe electron} $out/bin/pvzge \
      --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
      --add-flags $phome \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --inherit-argv0

    mkdir -p $out/share/pixmaps
    magick ${
      fetchurl {
        url = "https://raw.githubusercontent.com/Gzh0821/pvzg_site/refs/tags/${finalAttrs.version}/src/.vuepress/public/pvz_logo.webp";
        hash = "sha256-PkUS4iESw+R8o+tZMDJ+PTyu6PTmKeRkq/VG3+egsQY=";
        meta.license = lib.licenses.unfree;
      }
    } $out/share/pixmaps/pvzge.png

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "pvzge";
      exec = finalAttrs.meta.mainProgram;
      icon = "pvzge";
      desktopName = "PvZ2: Gardendless";
      comment = finalAttrs.meta.description;
      categories = [ "Game" ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Completely remastered PvZ2 for all desktop platforms";
    homepage = "https://pvzge.com";
    downloadPage = "https://pvzge.com/en/download";
    # upstream repo has GPL-3.0 in the LICENSE file,
    # but only obfuscated code is available, and it contains proprietary assets
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ ulysseszhan ];
    platforms = lib.platforms.all;
    mainProgram = "pvzge";
  };
})
