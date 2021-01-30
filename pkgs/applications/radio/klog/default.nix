{ lib, stdenv, fetchurl, hamlib, pkg-config, qt5, qtbase, qttools, qtserialport, qtcharts, qmake, wrapQtAppsHook }:

stdenv.mkDerivation rec {
  pname = "klog";
  version = "1.4.5";

  src = fetchurl {
    url = "https://download.savannah.nongnu.org/releases/klog/${pname}-${version}.tar.gz";
    sha256 = "sha256-aC96Tf9HszoR5N/YR6kx9qYT2Ypqw/pFUxyDUSsoZYU=";
  };

  nativeBuildInputs = [ pkg-config wrapQtAppsHook qmake qttools ];
  buildInputs = [ hamlib qtbase qtserialport qtcharts ];

  qmakeFlags = [ "KLog.pro" ];

  meta = with lib; {
    description = "A multiplatform free hamradio logger";
    longDescription = ''
      KLog provides QSO management, useful QSL management DX-Cluster client, DXCC management,
      ClubLog integration, WSJT-X, DX-Marathon support and much more.
      '';
    homepage = "https://www.klog.xyz/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pulsation ];
  };
}
