{ lib, stdenv, fetchFromGitHub, fetchpatch, ncurses, libvorbis, SDL }:

stdenv.mkDerivation rec {
  pname = "mp3blaster";
  version = "3.2.6";

  src = fetchFromGitHub {
    owner = "stragulus";
    repo = pname;
    rev = "v${version}";
    sha256 = "0pzwml3yhysn8vyffw9q9p9rs8gixqkmg4n715vm23ib6wxbliqs";
  };

  patches = [
    # Fix pending upstream inclusion for ncurses-6.3 support:
    #  https://github.com/stragulus/mp3blaster/pull/8
    (fetchpatch {
      name = "ncurses-6.3.patch";
      url = "https://github.com/stragulus/mp3blaster/commit/62168cba5eaba6ffe56943552837cf033cfa96ed.patch";
      sha256 = "088l27kl1l58lwxfnw5x2n64sdjy925ycphni3icwag7zvpj0xz1";
    })
  ];

  buildInputs = [
    ncurses
    libvorbis
  ] ++ lib.optional stdenv.isDarwin SDL;

  env.NIX_CFLAGS_COMPILE = toString ([
    "-Wno-narrowing"
  ] ++ lib.optionals stdenv.cc.isClang [
    "-Wno-reserved-user-defined-literal"
  ]);

  meta = with lib; {
    description = "Audio player for the text console";
    homepage = "http://www.mp3blaster.org/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ earldouglas ];
    platforms = with platforms; linux ++ darwin;
  };
}
