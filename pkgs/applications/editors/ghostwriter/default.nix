{ stdenv, fetchFromGitHub, qmake, pkgconfig, qtwebkit, hunspell }:

stdenv.mkDerivation rec {
  pname = "ghostwriter";
  version = "1.5.0";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "wereturtle";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ixw2w2526836lwj4pc0vp7prp1gls7iq37v8m9ql1508b33b9pq";
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
