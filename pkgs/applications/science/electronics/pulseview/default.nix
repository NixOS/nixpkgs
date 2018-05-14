{ stdenv, fetchurl, pkgconfig, cmake, glib, boost, libsigrok
, libsigrokdecode, libserialport, libzip, udev, libusb1, libftdi1, glibmm
, pcre, librevisa, python3, qtbase, qtsvg
}:

stdenv.mkDerivation rec {
  name = "pulseview-0.4.0";

  src = fetchurl {
    url = "https://sigrok.org/download/source/pulseview/${name}.tar.gz";
    sha256 = "1f8f2342d5yam98mmcb8f9g2vslcwv486bmi4x45pxn68l82ky3q";
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
