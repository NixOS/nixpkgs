{ stdenv, fetchFromGitHub, qmake, pkgconfig, qttools, qtwebengine, hunspell }:

stdenv.mkDerivation rec {
  pname = "ghostwriter";
  version = "1.8.0";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "wereturtle";
    repo = pname;
    rev = "v${version}";
    sha256 = "13yn82m1l2pq93wbl569a2lzpc3sn8a8g30hsgdch1l9xlmhwran";
  };

  nativeBuildInputs = [ qmake pkgconfig qttools ];

  buildInputs = [ qtwebengine hunspell ];

  meta = with stdenv.lib; {
    description = "A cross-platform, aesthetic, distraction-free Markdown editor";
    homepage = src.meta.homepage;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dotlambda ];
  };
}
