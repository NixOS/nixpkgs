{ stdenv, fetchFromGitHub, ncurses, libvorbis, SDL }:

stdenv.mkDerivation rec {
  pname = "mp3blaster";
  version = "3.2.6";

  src = fetchFromGitHub {
    owner = "stragulus";
    repo = pname;
    rev = "v${version}";
    sha256 = "0pzwml3yhysn8vyffw9q9p9rs8gixqkmg4n715vm23ib6wxbliqs";
  };

  buildInputs = [
    ncurses
    libvorbis
  ] ++ stdenv.lib.optional stdenv.isDarwin SDL;

  NIX_CFLAGS_COMPILE = toString ([
    "-Wno-narrowing"
  ] ++ stdenv.lib.optionals stdenv.cc.isClang [
    "-Wno-reserved-user-defined-literal"
  ]);

  meta = with stdenv.lib; {
    description = "An audio player for the text console";
    homepage = "http://www.mp3blaster.org/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ earldouglas ];
    platforms = with platforms; linux ++ darwin;
  };
}
