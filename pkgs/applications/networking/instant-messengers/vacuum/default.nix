{ stdenv, lib, fetchurl
  , qt4, openssl
  , xproto, libX11, libXScrnSaver, scrnsaverproto
  , xz, zlib
}:
stdenv.mkDerivation rec {
  name = "vacuum-im-${version}";
  version = "1.2.4";

  src = fetchurl {
    url = "https://googledrive.com/host/0B7A5K_290X8-d1hjQmJaSGZmTTA/vacuum-${version}.tar.gz";
    sha256 = "10qxpfbbaagqcalhk0nagvi5irbbz5hk31w19lba8hxf6pfylrhf";
  };

  buildInputs = [
    qt4 openssl xproto libX11 libXScrnSaver scrnsaverproto xz zlib
  ];

  hardeningDisable = [ "format" ];

  configurePhase = ''
    qmake INSTALL_PREFIX=$out -recursive vacuum.pro
  '';

  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    description = "An XMPP client fully composed of plugins";
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
    license = licenses.gpl3;
    homepage = "http://code.google.com/p/vacuum-im/";
  };
}
