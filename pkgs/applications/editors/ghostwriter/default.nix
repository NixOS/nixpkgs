{ stdenv, fetchFromGitHub, qmake, pkgconfig, qtwebkit, hunspell }:

stdenv.mkDerivation rec {
  pname = "ghostwriter";
  version = "1.6.1";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "wereturtle";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ihdr4xk0j83q83xknbikxb7yf9qhlkgvc89w33lhj090cv376gd";
  };

  nativeBuildInputs = [ qmake pkgconfig ];

  buildInputs = [ qtwebkit hunspell ];

  meta = with stdenv.lib; {
    description = "A cross-platform, aesthetic, distraction-free Markdown editor";
    homepage = src.meta.homepage;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dotlambda ];
  };
}
