{ stdenv, fetchurl, mpd_clientlib }:

stdenv.mkDerivation rec {
  version = "0.23";
  name = "mpc-${version}";

  src = fetchurl {
    url = "http://www.musicpd.org/download/mpc/0/${name}.tar.bz2";
    sha256 = "1ir96wfgq5qfdd2s06zfycv38g3bhn3bpndwx9hwf1w507rvifi9";
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
    license = "GPL2";
    maintainers = [ stdenv.lib.maintainers.algorith ];
    platforms = stdenv.lib.platforms.linux;
  };
}