{ stdenv, fetchurl, pkgconfig, cmake, glib, qt4, boost, libsigrok
, libsigrokdecode, libserialport, libzip, udev, libusb1, libftdi, glibmm
}:

stdenv.mkDerivation rec {
  name = "pulseview-0.3.0";

  src = fetchurl {
    url = "http://sigrok.org/download/source/pulseview/${name}.tar.gz";
    sha256 = "03jk5xpsird5ssbnwkxw57jnqvnnpivhqh1xjdhdrz02lsvjrzjz";
  };

  buildInputs = [ pkgconfig cmake glib qt4 boost libsigrok
    libsigrokdecode libserialport libzip udev libusb1 libftdi glibmm
  ];

  meta = with stdenv.lib; {
    description = "Qt-based LA/scope/MSO GUI for sigrok (a signal analysis software suite)";
    homepage = http://sigrok.org/;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
