{ stdenv, fetchurl, qt4, openssl, xproto, libX11
, libXScrnSaver, scrnsaverproto, xz
}:

stdenv.mkDerivation rec {
  name="${baseName}-${version}";
  baseName = "vacuum-im";
  version = "1.2.4";

  src = fetchurl {
    url="https://googledrive.com/host/0B7A5K_290X8-d1hjQmJaSGZmTTA/vacuum-1.2.4.tar.gz";
    sha256="10qxpfbbaagqcalhk0nagvi5irbbz5hk31w19lba8hxf6pfylrhf";
  };

  configurePhase = "qmake INSTALL_PREFIX=$out -recursive vacuum.pro";

  hardening_format = false;

  buildInputs = [
    qt4 openssl xproto libX11 libXScrnSaver scrnsaverproto xz
  ];

  meta = with stdenv.lib; {
    description = "An XMPP client fully composed of plugins";
    maintainers = with maintainers; [ raskin ];
    platforms = with platforms; linux;
    license = with licenses; gpl3;
    homepage = "http://code.google.com/p/vacuum-im/";
  };
}

