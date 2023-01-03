{ alsa-lib
, cups
, dpkg
, fetchurl
, gjs
, glib
, gtk3
, lib
, libdrm
, libgcrypt
, libkrb5
, mesa # for libgbm
, nss
, xorg
, systemd
, stdenv
, at-spi2-core
, autoPatchelfHook
, wrapGAppsHook
, copyDesktopItems
, makeDesktopItem
}:

let
  version = "2.0.3-543";
  srcs = {
    x86_64-linux = fetchurl {
      url = "https://dldir1.qq.com/qqfile/qq/QQNT/50eed662/QQ-v${version}_x64.deb";
      sha256 = "sha256-O8zaVHt/oXserPVHe/r6pAFpWFeLDVsiaazgaX7kxu8=";
    };
    aarch64-linux = fetchurl {
      url = "https://dldir1.qq.com/qqfile/qq/QQNT/50eed662/QQ-v${version}_arm64.deb";
      sha256 = "sha256-01ZpcoSDc5b0MCKAMq16N4cXzbouHNckOGsv+Z4et7w=";
    };
  };
  src = srcs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation {
  pname = "qq";
  inherit version src;

  unpackCmd = "dpkg-deb -x $curSrc source";

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook
    copyDesktopItems
    dpkg
  ];

  buildInputs = [
    alsa-lib
    at-spi2-core
    cups
    libdrm
    libgcrypt
    libkrb5
    mesa
    nss
    xorg.libXdamage
  ];

  runtimeDependencies = [
    gtk3
    (lib.getLib systemd)
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/share/icons/hicolor/0x0/apps"
    cp usr/share/icons/hicolor/0x0/apps/qq.png $out/share/icons/hicolor/0x0/apps

    mkdir -p "$out/opt"
    cp -r "opt/"* $out/opt

    mkdir -p "$out/bin"
    ln -s "$out/opt/QQ/qq" "$out/bin/qq"
    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      desktopName = "Tencent QQ";
      genericName = "A messaging app";
      categories = [ "Network" ];
      icon = "qq";
      exec = "qq";
      name = "qq";
    })
  ];

  meta = with lib; {
    homepage = "https://im.qq.com/linuxqq/";
    description = "Messaging app";
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    license = licenses.unfree;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ fee1-dead ];
  };
}
