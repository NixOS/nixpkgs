{ stdenv, mkDerivation, fetchFromGitHub, qmake, pkgconfig, qttools, qtwebengine, hunspell }:

mkDerivation rec {
  pname = "ghostwriter";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "wereturtle";
    repo = pname;
    rev = "v${version}";
    sha256 = "0jc6szfh5sdnafhwsr1xv7cn1fznniq58bix41hb9wlbkvq7wzi6";
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
