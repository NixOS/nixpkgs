{stdenv, fetchFromGitHub, pkgconfig, libltc, libsndfile, jack2}:

stdenv.mkDerivation rec {
  name = "ltc-tools-${version}";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "x42";
    repo = "ltc-tools";
    rev = "v${version}";
    sha256 = "0vp25b970r1hv5ndzs4di63rgwnl31jfaj3jz5dka276kx34q4al";
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
