{ lib
, stdenv
, fetchurl
, dpkg
, wrapGAppsHook
, autoPatchelfHook
, openssl
, webkitgtk
, udev
, libayatana-appindicator
}:

stdenv.mkDerivation rec {
  pname = "clash-verge";
  version = "1.3.1";

  src = fetchurl {
    url = "https://github.com/zzzgydi/clash-verge/releases/download/v${version}/clash-verge_${version}_amd64.deb";
    hash = "sha256-AEOFMKxrkPditf5ks++tII6zeuH72Fxw/TVtZeXS3v4=";
  };

  unpackPhase = "dpkg-deb -x $src .";

  nativeBuildInputs = [
    dpkg
    wrapGAppsHook
    autoPatchelfHook
  ];

  buildInputs = [
    openssl
    webkitgtk
    stdenv.cc.cc
  ];

  runtimeDependencies = [
    (lib.getLib udev)
    libayatana-appindicator
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mv usr/* $out

    runHook postInstall
  '';

  meta = with lib; {
    description = "A Clash GUI based on tauri";
    homepage = "https://github.com/zzzgydi/clash-verge";
    platforms = [ "x86_64-linux" ];
    license = licenses.gpl3Plus;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ zendo ];
  };
}
