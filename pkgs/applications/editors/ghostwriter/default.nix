{ lib, stdenv, mkDerivation, fetchFromGitHub, qmake, pkg-config, qttools, qtwebengine, hunspell }:

mkDerivation rec {
  pname = "ghostwriter";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "wereturtle";
    repo = pname;
    rev = version;
    sha256 = "sha256-bNVhYwX60F3lrP9UmZSntfz83vbmHe9tu/4nUgzUWR4=";
  };

  nativeBuildInputs = [ qmake pkg-config qttools ];

  buildInputs = [ qtwebengine hunspell ];

  meta = with lib; {
    description = "A cross-platform, aesthetic, distraction-free Markdown editor";
    homepage = src.meta.homepage;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dotlambda erictapen ];
    broken = stdenv.isDarwin;
  };
}
