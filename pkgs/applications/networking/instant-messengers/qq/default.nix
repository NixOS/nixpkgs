{ alsa-lib
, cups
, dpkg
, fetchurl
, gjs
, glib
, gtk3
, lib
<<<<<<< HEAD
, libayatana-appindicator
=======
, libappindicator
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
, makeWrapper
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
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };
  };
  src = srcs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation {
  pname = "qq";
  inherit version src;

<<<<<<< HEAD
  nativeBuildInputs = [
    autoPatchelfHook
    # makeBinaryWrapper not support shell wrapper specifically for `NIXOS_OZONE_WL`.
    (wrapGAppsHook.override { inherit makeWrapper; })
=======
  unpackCmd = "dpkg-deb -x $curSrc source";

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
=======
    libappindicator
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
    # https://aur.archlinux.org/cgit/aur.git/commit/?h=linuxqq&id=f7644776ee62fa20e5eb30d0b1ba832513c77793
    rm -r $out/opt/QQ/resources/app/libssh2.so.1

    # https://github.com/microcai/gentoo-zh/commit/06ad5e702327adfe5604c276635ae8a373f7d29e
    ln -s ${libayatana-appindicator}/lib/libayatana-appindicator3.so \
      $out/opt/QQ/libappindicator3.so

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    runHook postInstall
  '';

  preFixup = ''
<<<<<<< HEAD
    gappsWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath [ gjs ]}"
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"
    )
=======
    gappsWrapperArgs+=(--prefix PATH : "${lib.makeBinPath [ gjs ]}")
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
