{
  lib,
  stdenv,
  fetchurl,
  hamlib,
  pkg-config,
  libsForQt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "klog";
  version = "1.3.2";

  src = fetchurl {
    url = "mirror://savannah/${finalAttrs.pname}/${finalAttrs.pname}-${finalAttrs.version}.tar.gz";
    sha256 = "1d5x7rq0mgfrqws3q1y4z8wh2qa3gvsmd0ssf2yqgkyq3fhdrb5c";
  };

  nativeBuildInputs = [
    pkg-config
    libsForQt5.wrapQtAppsHook
    libsForQt5.qmake
    libsForQt5.qttools
  ];
  buildInputs = [
    hamlib
    libsForQt5.qtbase
    libsForQt5.qtserialport
    libsForQt5.qtcharts
  ];

  qmakeFlags = [ "KLog.pro" ];

  meta = {
    description = "Multiplatform free hamradio logger";
    mainProgram = "klog";
    longDescription = ''
      KLog provides QSO management, useful QSL management DX-Cluster client, DXCC management,
      ClubLog integration, WSJT-X, DX-Marathon support and much more.
    '';
    homepage = "https://www.klog.xyz/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ pulsation ];
  };
})
