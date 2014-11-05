{ stdenv, fetchurl, pkgconfig, cmake, glib, qt4, boost, libsigrok
, libsigrokdecode, libserialport, libzip, udev, libusb1, libftdi
}:

stdenv.mkDerivation rec {
  name = "pulseview-0.2.0";

  src = fetchurl {
    url = "http://sigrok.org/download/source/pulseview/${name}.tar.gz";
    sha256 = "1pf1dgwd9j586nqmni6gqf3qxrsmawcmi9wzqfzqkjci18xd7dgy";
  };

  buildInputs = [ pkgconfig cmake glib qt4 boost libsigrok
    libsigrokdecode libserialport libzip udev libusb1 libftdi
  ];

  meta = with stdenv.lib; {
    description = "Qt-based LA/scope/MSO GUI for sigrok (a signal analysis software suite)";
    homepage = http://sigrok.org/;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
