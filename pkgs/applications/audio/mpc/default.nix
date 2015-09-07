{ stdenv, fetchurl, mpd_clientlib }:

stdenv.mkDerivation rec {
  version = "0.27";
  name = "mpc-${version}";

  src = fetchurl {
    url = "http://www.musicpd.org/download/mpc/0/${name}.tar.xz";
    sha256 = "0r10wsqxsi07gns6mfnicvpci0sbwwj4qa9iyr1ysrgadl5bx8j5";
  };

  buildInputs = [ mpd_clientlib ];

  preConfigure =
    ''
      export LIBMPDCLIENT_LIBS=${mpd_clientlib}/lib/libmpdclient.${if stdenv.isDarwin then mpd_clientlib.majorVersion + ".dylib" else "so." + mpd_clientlib.majorVersion + ".0." + mpd_clientlib.minorVersion}
      export LIBMPDCLIENT_CFLAGS=${mpd_clientlib}
    '';

  meta = with stdenv.lib; {
    description = "A minimalist command line interface to MPD";
    homepage = http://www.musicpd.org/clients/mpc/;
    license = licenses.gpl2;
    maintainers = [ maintainers.algorith ];
    platforms = with platforms; linux ++ darwin;
  };
}
