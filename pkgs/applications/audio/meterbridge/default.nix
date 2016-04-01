{ stdenv, fetchurl, pkgconfig, SDL, SDL_image, libjack2
}:

stdenv.mkDerivation rec {
  version = "0.9.2";
  name = "meterbridge-${version}";

  src = fetchurl {
    url = "http://plugin.org.uk/meterbridge/${name}.tar.gz";
    sha256 = "0jb6g3kbfyr5yf8mvblnciva2bmc01ijpr51m21r27rqmgi8gj5k";
  };

  patches = [ ./buf_rect.patch ./fix_build_with_gcc-5.patch];

  buildInputs =
    [ pkgconfig SDL SDL_image libjack2
    ];

  meta = with stdenv.lib; {
    description = "Various meters (VU, PPM, DPM, JF, SCO) for Jack Audio Connection Kit";
    homepage = http://plugin.org.uk/meterbridge/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.nico202 ];
  };
}
