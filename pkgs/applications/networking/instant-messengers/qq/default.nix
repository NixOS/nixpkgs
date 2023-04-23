{ alsa-lib
, cups
, dpkg
, fetchurl
, gjs
, glib
, gtk3
, lib
, libappindicator
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
  version = "3.1.1-11223";
  srcs = {
    x86_64-linux = fetchurl {
      url = "https://dldir1.qq.com/qqfile/qq/QQNT/2355235c/linuxqq_${version}_amd64.deb";
      sha256 = "sha256-TBgQ7zV+juB3KSgIIXuvxnYmvnnM/1/wU0EkiopIqvY=";
    };
    aarch64-linux = fetchurl {
      url = "https://dldir1.qq.com/qqfile/qq/QQNT/2355235c/linuxqq_${version}_arm64.deb";
      sha256 = "sha256-1ba/IA/+X/s7jUtIhh3OsBHU7MPggGrASsBPx8euBBs=";
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
    libappindicator
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
