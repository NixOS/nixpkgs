{ alsa-lib
, cups
, dpkg
, fetchurl
, gjs
, glib
, gtk3
, lib
, libayatana-appindicator
, libdrm
, libgcrypt
, libkrb5
, mesa # for libgbm
, nss
, xorg
, systemd
, stdenv
, vips
, at-spi2-core
, autoPatchelfHook
, wrapGAppsHook
}:

let
  version = "3.1.2-13107";
  _hash = "ad5b5393";
  srcs = {
    x86_64-linux = fetchurl {
      url = "https://dldir1.qq.com/qqfile/qq/QQNT/${_hash}/linuxqq_${version}_amd64.deb";
      hash = "sha256-mBfeexWEYpGybFFianUFvlzMv0HoFR4EeFcwlGVXIRA=";
    };
    aarch64-linux = fetchurl {
      url = "https://dldir1.qq.com/qqfile/qq/QQNT/${_hash}/linuxqq_${version}_arm64.deb";
      hash = "sha256-V6kR2lb63nnNIEhn64Yg0BYYlz7W0Cw60TwnKaJuLgs=";
    };
  };
  src = srcs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation {
  pname = "qq";
  inherit version src;

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook
    dpkg
  ];

  buildInputs = [
    alsa-lib
    at-spi2-core
    cups
    glib
    gtk3
    libdrm
    libgcrypt
    libkrb5
    mesa
    nss
    vips
    xorg.libXdamage
  ];

  runtimeDependencies = map lib.getLib [
    systemd
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r opt $out/opt
    cp -r usr/share $out/share
    substituteInPlace $out/share/applications/qq.desktop \
      --replace "/opt/QQ/qq" "$out/bin/qq" \
      --replace "/usr/share" "$out/share"
    ln -s $out/opt/QQ/qq $out/bin/qq

    # Remove bundled libraries
    rm -r $out/opt/QQ/resources/app/sharp-lib

    # https://github.com/microcai/gentoo-zh/commit/06ad5e702327adfe5604c276635ae8a373f7d29e
    ln -s ${libayatana-appindicator}/lib/libayatana-appindicator3.so \
      $out/opt/QQ/libappindicator3.so

    runHook postInstall
  '';

  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : "${lib.makeBinPath [ gjs ]}")
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
