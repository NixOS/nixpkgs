{ stdenv, mkDerivation, fetchFromGitHub, qmake, pkgconfig, qttools, qtwebengine, hunspell }:

mkDerivation rec {
  pname = "ghostwriter";
  version = "2.0.0-rc3";

  src = fetchFromGitHub {
    owner = "wereturtle";
    repo = pname;
    rev = version;
    sha256 = "sha256-Ag97iE++f3nG2zlwqn0qxSL9RpF8O3XWH9NtQ5kFuWg=";
  };

  nativeBuildInputs = [ qmake pkgconfig qttools ];

  buildInputs = [ qtwebengine hunspell ];

  meta = with stdenv.lib; {
    description = "A cross-platform, aesthetic, distraction-free Markdown editor";
    homepage = src.meta.homepage;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dotlambda erictapen ];
    broken = stdenv.isDarwin;
  };
}
