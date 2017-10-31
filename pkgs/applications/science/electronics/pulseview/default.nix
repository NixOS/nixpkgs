{ stdenv, fetchurl, pkgconfig, cmake, glib, qt5, boost, libsigrok
, libsigrokdecode, libserialport, libzip, udev, libusb1, libftdi1, glibmm
}:

stdenv.mkDerivation rec {
  name = "pulseview-0.4.0";

  src = fetchurl {
    url = "http://sigrok.org/download/source/pulseview/${name}.tar.gz";
    sha256 = "1f8f2342d5yam98mmcb8f9g2vslcwv486bmi4x45pxn68l82ky3q";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cmake glib qt5.full boost libsigrok
    libsigrokdecode libserialport libzip udev libusb1 libftdi1 glibmm
  ];

  meta = with stdenv.lib; {
    description = "Qt-based LA/scope/MSO GUI for sigrok (a signal analysis software suite)";
    homepage = http://sigrok.org/;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
