{ lib
, stdenv
, fetchurl
, alsa-lib
, autoPatchelfHook
, dpkg
, gtk3
, makeWrapper
, mesa
, nss
, systemd
, xorg
}:

stdenv.mkDerivation rec {
  pname = "join-desktop";
  version = "1.1.2";

  src = fetchurl {
    url = "https://github.com/joaomgcd/JoinDesktop/releases/download/v${version}/com.joaomgcd.join_${version}_amd64.deb";
    sha256 = "sha256-k1LX/HC3tfL4Raipo7wp/LnfrPa38x8NBeKRyHJ72CU=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    gtk3
    mesa
    nss
    xorg.libXScrnSaver
    xorg.libXtst
  ];

  unpackPhase = "dpkg-deb -x $src .";

  runtimeDependencies = [
    (lib.getLib systemd)
    # TODO: check if they are required
    # libnotify
    # libappindicator
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/join-desktop

    mv usr/share/* $out/share
    mv opt/Join\ Desktop/* $out/share/join-desktop

    ln -s $out/share/join-desktop/com.joaomgcd.join $out/bin/

    substituteInPlace $out/share/applications/com.joaomgcd.join.desktop \
      --replace "/opt/Join Desktop/com.joaomgcd.join" "com.joaomgcd.join"

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/joaomgcd/JoinDesktop/";
    description = "Desktop app for Join";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    # on https://joaoapps.com/join/desktop/ "Join Desktop is an open source app" but no license
    license = licenses.free;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ SuperSandro2000 ];
  };

}
