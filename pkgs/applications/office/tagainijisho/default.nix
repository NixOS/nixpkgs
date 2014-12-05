{stdenv, fetchurl, qt4, cmake, sqlite}:

stdenv.mkDerivation {
  name = "tagainijisho-1.0.2";
  src = fetchurl {
    url = https://github.com/Gnurou/tagainijisho/releases/download/1.0.2/tagainijisho-1.0.2.tar.gz;
    sha256 = "0gvwsphy2a1b2npxkzvaf91rbzb00zhi2anxd5102h6ld5m52jhl";
  };

  buildInputs = [ qt4 cmake sqlite ];

  meta = with stdenv.lib; {
    description = "A free, open-source Japanese dictionary and kanji lookup tool";
    homepage = http://www.tagaini.net/;
    license = with licenses; [
      /* program */ gpl3Plus
      /* data */ cc-by-sa-30
    ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ vbgl ];
  };
}
