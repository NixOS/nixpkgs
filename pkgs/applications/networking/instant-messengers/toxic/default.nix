{ stdenv, fetchFromGitHub, libsodium, ncurses, curl
, libtoxcore-dev, openal, libvpx, freealut, libconfig, pkgconfig
, libqrencode }:

stdenv.mkDerivation rec {
  name = "toxic-dev-20160728";

  src = fetchFromGitHub {
    owner = "Tox";
    repo = "toxic";
    rev = "cb21672600206423c844306a84f8b122e534c348";
    sha256 = "1nq1xnbyjfrk8jrjvk5sli1bm3i9r8b4m8f4xgmiz68mx1r3fn5k";
  };

  makeFlags = [ "PREFIX=$(out)" ];
  installFlags = [ "PREFIX=$(out)" ];

  nativeBuildInputs = [ pkgconfig libconfig ];
  buildInputs = [
    libtoxcore-dev libsodium ncurses libqrencode curl
  ] ++ stdenv.lib.optionals (!stdenv.isArm) [
    openal libvpx freealut
  ];

  meta = with stdenv.lib; {
    description = "Reference CLI for Tox";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ viric jgeerds ];
    platforms = platforms.all;
  };
}
