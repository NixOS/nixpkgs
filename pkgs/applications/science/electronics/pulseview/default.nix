{ stdenv, fetchurl, pkgconfig, cmake, glib, boost, libsigrok
, libsigrokdecode, libserialport, libzip, udev, libusb1, libftdi1, glibmm
, pcre, librevisa, python3, qtbase, qtsvg
}:

stdenv.mkDerivation rec {
  name = "pulseview-0.4.1";

  src = fetchurl {
    url = "https://sigrok.org/download/source/pulseview/${name}.tar.gz";
    sha256 = "0bvgmkgz37n2bi9niskpl05hf7rsj1lj972fbrgnlz25s4ywxrwy";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    glib boost libsigrok libsigrokdecode libserialport libzip udev libusb1 libftdi1 glibmm
    pcre librevisa python3 qtbase qtsvg
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Qt-based LA/scope/MSO GUI for sigrok (a signal analysis software suite)";
    homepage = https://sigrok.org/;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
