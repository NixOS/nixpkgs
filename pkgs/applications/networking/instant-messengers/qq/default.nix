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
, makeWrapper
}:

let
  version = "3.0.0-571";
  srcs = {
    x86_64-linux = fetchurl {
      url = "https://dldir1.qq.com/qqfile/qq/QQNT/c005c911/linuxqq_${version}_amd64.deb";
      sha256 = "sha256-8KcUhZwgeFzGyrQITWnJUzEPGZOCj0LIHLmRuKqkgmQ=";
    };
    aarch64-linux = fetchurl {
      url = "https://dldir1.qq.com/qqfile/qq/QQNT/c005c911/linuxqq_${version}_arm64.deb";
      sha256 = "sha256-LvE+Pryq4KLu+BFYVrGiTwBdgOrBguPHQd73MMFlfiY=";
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
    makeWrapper
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

    mkdir -p $out/bin
    cp -r opt $out/opt
    cp -r usr/share $out/share
    substituteInPlace $out/share/applications/qq.desktop \
      --replace "/opt/QQ/qq" "$out/bin/qq" \
      --replace "/usr/share" "$out/share"
    makeWrapper $out/opt/QQ/qq $out/bin/qq \
      --argv0 "qq" \
      --prefix GTK_IM_MODULE_FILE : "/run/current-system/sw/etc/gtk-3.0/immodules.cache"

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://im.qq.com/linuxqq/";
    description = "Messaging app";
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    license = licenses.unfree;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ fee1-dead ];
  };
}
