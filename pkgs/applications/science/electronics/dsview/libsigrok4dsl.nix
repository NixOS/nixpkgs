{ stdenv, pkgconfig, autoreconfHook,
glib, libzip, libserialport, check, libusb, libftdi,
systemd, alsaLib, dsview
}:

stdenv.mkDerivation rec {
  inherit (dsview) version src;

  name = "libsigrok4dsl-${version}";

  postUnpack = ''
    export sourceRoot=$sourceRoot/libsigrok4DSL
  '';

  nativeBuildInputs = [ pkgconfig autoreconfHook ];

  buildInputs = [
    glib libzip libserialport libusb libftdi systemd check alsaLib
  ];

  meta = with stdenv.lib; {
    description = "A fork of the sigrok library for usage with DSView";
    homepage = http://www.dreamsourcelab.com/;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bachp ];
  };
}
