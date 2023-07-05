{lib, stdenv, fetchFromGitHub, pkg-config, libltc, libsndfile, jack2}:

stdenv.mkDerivation rec {
  pname = "ltc-tools";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "x42";
    repo = "ltc-tools";
    rev = "v${version}";
    sha256 = "0vp25b970r1hv5ndzs4di63rgwnl31jfaj3jz5dka276kx34q4al";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libltc libsndfile jack2 ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://github.com/x42/ltc-tools";
    description = "Tools to deal with linear-timecode (LTC)";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ tg-x ];
  };
}
