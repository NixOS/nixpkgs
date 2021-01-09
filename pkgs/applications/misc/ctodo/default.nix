{ stdenv, fetchFromGitHub, cmake, ncurses, readline }:

stdenv.mkDerivation rec {
  pname = "ctodo";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "Acolarh";
    repo = pname;
    rev = "v${version}";
    sha256 = "0mqy5b35cbdwfpbs91ilsgz3wc4cky38xfz9pnr4q88q1vybigna";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ ncurses readline ];

  meta = with stdenv.lib; {
    homepage = "http://ctodo.apakoh.dk/";
    description = "A simple ncurses-based task list manager";
    license = licenses.mit;
    maintainers = [ maintainers.matthiasbeyer ];
    platforms = platforms.unix;
  };
}
