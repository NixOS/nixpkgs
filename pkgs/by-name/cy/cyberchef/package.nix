{
  lib,
  copyDesktopItems,
  fetchzip,
  fetchurl,
  stdenv,
  makeDesktopItem,
}:

let
  icon = fetchurl {
    url = "https://raw.githubusercontent.com/gchq/CyberChef/c57556f49f723863b9be15668fd240672cd15b09/src/web/static/images/cyberchef-512x512.png";
    hash = "sha256-Lg9JbVHhdILdrRtxYFWSv9HNJUx98JOaTbs+IbS1eO0=";
  };
  version = "10.21.0";
in
stdenv.mkDerivation {
  pname = "cyberchef";
  inherit version;

  src = fetchzip {
    url = "https://github.com/gchq/CyberChef/releases/download/v${version}/CyberChef_v${version}.zip";
    hash = "sha256-5w5Bl8LAmpx3dHAwfq4ALKKoS6zRBsh1X7p7ek4dy/s=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    copyDesktopItems
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/cyberchef"
    mkdir -p "$out/bin"

    mv "CyberChef_v${version}.html" index.html
    mv * "$out/share/cyberchef"

    cat <<INI > $out/bin/cyberchef
    #!/bin/sh
    xdg-open $out/share/cyberchef/index.html
    INI

    chmod +x $out/bin/cyberchef

    install -m 444 -D ${icon} $out/share/icons/hicolor/512x512/apps/cyberchef.png

    mkdir -p $out/share/applications/

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "cyberchef";
      desktopName = "Cyberchef";
      exec = "cyberchef";
      icon = "cyberchef";
      comment = "Cyber Swiss Army Knife for encryption, encoding, compression and data analysis";
      categories = [ "Development" ];
    })
  ];

  meta = {
    description = "Cyber Swiss Army Knife for encryption, encoding, compression and data analysis";
    homepage = "https://gchq.github.io/CyberChef";
    changelog = "https://github.com/gchq/CyberChef/blob/v${version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [
      sebastianblunt
      aldenparker
    ];
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
}
