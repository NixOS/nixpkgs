{ stdenv, fetchurl, pkgconfig, ccache, makeWrapper, qmake4Hook, qt4, libftdi1, alsaLib, libudev, libusb}:

stdenv.mkDerivation rec {
  name = "qlcplus-${version}";
  version = "4.10.4";

  src = fetchurl {
    url = "http://www.qlcplus.org/downloads/${version}/qlcplus_${version}.tar.gz";
    sha256 = "0khwv6bgjllci56g4khzmqkmhhvz5rmr93466qyvnqrcxvn5mdql";
  };

  preConfigure = ''
    substituteInPlace ./variables.pri \
      --replace "INSTALLROOT += /usr" "INSTALLROOT = $out"
  '';

  buildInputs = [ ccache libudev pkgconfig libftdi1 qmake4Hook makeWrapper qt4 alsaLib libusb ];

  qmakeFlags = [ 
    "QMAKE_CXXFLAGS+=-Wno-error=unused-variable"
  ];
  
  dontAddPrefix = true;
  installFlags = [ "INSTALL_ROOT=/" ];


  postFixup= ''
    wrapProgram $out/bin/qlcplus \
      --prefix LD_LIBRARY_PATH : $out/lib
    wrapProgram $out/bin/qlcplus-fixtureeditor \
      --prefix LD_LIBRARY_PATH : $out/lib
  '';

  meta = {
    description = "The open DMX lighting desk software for controlling professional lighting fixtures";
    homepage = http://www.qlcplus.org;
    license = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [ sleexyz ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
