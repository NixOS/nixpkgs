{ stdenv, fetchFromGitHub, autoconf, libtool, automake, libsodium, ncurses
, libtoxcore, openal, libvpx, freealut, libconfig, pkgconfig }:

stdenv.mkDerivation rec {
  name = "toxic-dev-20150125";

  src = fetchFromGitHub {
    owner = "Tox";
    repo = "toxic";
    rev = "4badc983ea";
    sha256 = "01zk6316v51f1zvp5ss53ay49h3nnaq5snlk0gxmsrmwg71bsnm6";
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
