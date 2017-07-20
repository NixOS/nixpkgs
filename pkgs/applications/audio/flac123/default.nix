{ stdenv, fetchurl, autoreconfHook, flac, libao, libogg, popt }:

stdenv.mkDerivation rec {
  name = "flac123-${version}";
  version = "0.0.12";

  src = fetchurl {
    url = "mirror://sourceforge/flac-tools/${name}-release.tar.gz";
    sha256 = "0zg4ahkg7v81za518x32wldf42g0rrvlrcqhrg9sv3li9bayyxhr";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ flac libao libogg popt ];

  meta = with stdenv.lib; {
    homepage = http://flac-tools.sourceforge.net/;
    description = "A command-line program for playing FLAC audio files";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
  };
}
