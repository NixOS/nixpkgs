{ stdenv, fetchFromGitHub, autoconf, libtool, automake, libsodium, ncurses
, libtoxcore, openal, libvpx, freealut, libconfig, pkgconfig }:

stdenv.mkDerivation rec {
  name = "toxic-dev-20141130";

  src = fetchFromGitHub {
    owner = "Tox";
    repo = "toxic";
    rev = "4acfe84171";
    sha256 = "1yqglh9fm75zph4fzf3z4gwmamngypwpvb7shpqgakdg8ybq0a8s";
  };

  makeFlags = [ "-Cbuild" "PREFIX=$(out)" ];
  installFlags = [ "PREFIX=$(out)" ];

  buildInputs = [
    autoconf libtool automake libtoxcore libsodium ncurses
    libconfig pkgconfig
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
