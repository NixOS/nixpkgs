{ lib, stdenv, fetchurl, hamlib, pkg-config, qtbase, qttools, qtserialport, qtcharts, qmake, wrapQtAppsHook }:

stdenv.mkDerivation rec {
  pname = "klog";
  version = "1.3.2";

  src = fetchurl {
    url = "https://download.savannah.nongnu.org/releases/klog/${pname}-${version}.tar.gz";
    sha256 = "1d5x7rq0mgfrqws3q1y4z8wh2qa3gvsmd0ssf2yqgkyq3fhdrb5c";
  };

  nativeBuildInputs = [ pkg-config wrapQtAppsHook qmake qttools ];
  buildInputs = [ hamlib qtbase qtserialport qtcharts ];

  qmakeFlags = [ "KLog.pro" ];

  meta = with lib; {
    description = "Multiplatform free hamradio logger";
    mainProgram = "klog";
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
