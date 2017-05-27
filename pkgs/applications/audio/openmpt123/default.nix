{ stdenv, fetchurl, SDL2, pkgconfig, flac, libsndfile }:

let
  version = "0.2.7025-beta20.1";
in stdenv.mkDerivation rec {
  name = "openmpt123-${version}";
  src = fetchurl {
    url = "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-${version}.tar.gz";
    sha256 = "0qp2nnz6pnl1d7yv9hcjyim7q6yax5881k1jxm8jfgjqagmz5k6p";
  };
  buildInputs = [ SDL2 pkgconfig flac libsndfile ];
  makeFlags = [ "NO_PULSEAUDIO=1 NO_LTDL=1 TEST=0 EXAMPLES=0" ]
  ++ stdenv.lib.optional (stdenv.isDarwin) "SHARED_SONAME=0";
  installFlags = "PREFIX=\${out}";

  meta = with stdenv.lib; {
    description = "A cross-platform command-line based module file player";
    homepage = https://lib.openmpt.org/libopenmpt/;
    license = licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.gnidorah ];
    platforms = stdenv.lib.platforms.unix;
  };
}
