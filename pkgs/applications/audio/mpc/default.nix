{ stdenv, fetchurl, mpd_clientlib }:

stdenv.mkDerivation rec {
  version = "0.26";
  name = "mpc-${version}";

  src = fetchurl {
    url = "http://www.musicpd.org/download/mpc/0/${name}.tar.xz";
    sha256 = "0hp2qv6w2v902dhrmck5hg32s1ai6xiv9n61a3n6prfcfdqmywr0";
  };

  buildInputs = [ mpd_clientlib ];

  preConfigure =
    ''
      export LIBMPDCLIENT_LIBS=${mpd_clientlib}/lib/libmpdclient.so.${mpd_clientlib.majorVersion}.0.${mpd_clientlib.minorVersion}
      export LIBMPDCLIENT_CFLAGS=${mpd_clientlib}
    '';

  meta = {
    description = "A minimalist command line interface to MPD";
    homepage = http://www.musicpd.org/clients/mpc/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.algorith ];
    platforms = stdenv.lib.platforms.linux;
  };
}
