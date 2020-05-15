{ stdenv, fetchFromGitHub, ncurses, libvorbis, SDL }:
stdenv.mkDerivation rec {

  version = "3.2.6";

  pname = "mp3blaster";

  src = fetchFromGitHub {
    owner = "stragulus";
    repo = "mp3blaster";
    rev = "v${version}";
    sha256 = "0pzwml3yhysn8vyffw9q9p9rs8gixqkmg4n715vm23ib6wxbliqs";
  };

  buildInputs = [
    ncurses
    libvorbis
  ] ++ stdenv.lib.optional stdenv.isDarwin SDL;

  buildFlags = [ "CXXFLAGS=-Wno-narrowing" ];

  meta = with stdenv.lib; {
    description = "An audio player for the text console";
    homepage = "http://www.mp3blaster.org/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ earldouglas ];
    platforms = platforms.all;
  };

}
