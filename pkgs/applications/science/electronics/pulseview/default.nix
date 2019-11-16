{ mkDerivation, lib, fetchurl, pkgconfig, cmake, glib, boost, libsigrok
, libsigrokdecode, libserialport, libzip, udev, libusb1, libftdi1, glibmm
, pcre, librevisa, python3, qtbase, qtsvg
}:

mkDerivation rec {
  pname = "pulseview";
  version = "0.4.1";

  src = fetchurl {
    url = "https://sigrok.org/download/source/pulseview/${pname}-${version}.tar.gz";
    sha256 = "0bvgmkgz37n2bi9niskpl05hf7rsj1lj972fbrgnlz25s4ywxrwy";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    glib boost libsigrok libsigrokdecode libserialport libzip udev libusb1 libftdi1 glibmm
    pcre librevisa python3
    qtbase qtsvg
  ];

  meta = with lib; {
    description = "Qt-based LA/scope/MSO GUI for sigrok (a signal analysis software suite)";
    homepage = https://sigrok.org/;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ bjornfor ];
    platforms = platforms.linux;
  };
}
