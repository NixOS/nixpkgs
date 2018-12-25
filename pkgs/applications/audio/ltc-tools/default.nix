{stdenv, fetchFromGitHub, pkgconfig, libltc, libsndfile, jack2}:

stdenv.mkDerivation rec {
  name = "ltc-tools-${version}";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "x42";
    repo = "ltc-tools";
    rev = "v${version}";
    sha256 = "1a7r99mwc7p5j5y453mrgph67wlznd674v4k2pfmlvc91s6lh44y";
  };

  buildInputs = [ pkgconfig libltc libsndfile jack2 ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/x42/ltc-tools";
    description = "Tools to deal with linear-timecode (LTC)";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ tg-x ];
  };
}
