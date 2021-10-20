{ lib, stdenv, pkg-config, autoreconfHook,
glib, libzip, libserialport, check, libusb1, libftdi,
systemd, alsa-lib, dsview
}:

stdenv.mkDerivation {
  inherit (dsview) version src;

  pname = "libsigrok4dsl";

  postUnpack = ''
    export sourceRoot=$sourceRoot/libsigrok4DSL
  '';

  nativeBuildInputs = [ pkg-config autoreconfHook ];

  buildInputs = [
    glib libzip libserialport libusb1 libftdi systemd check alsa-lib
  ];

  meta = with lib; {
    description = "A fork of the sigrok library for usage with DSView";
    homepage = "https://www.dreamsourcelab.com/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bachp ];
  };
}
