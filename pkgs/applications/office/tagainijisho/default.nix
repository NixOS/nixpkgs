{ stdenv, fetchurl, qt4, cmake, sqlite }:

stdenv.mkDerivation {
  name = "tagainijisho-1.0.3";
  src = fetchurl {
    url = https://github.com/Gnurou/tagainijisho/releases/download/1.0.3/tagainijisho-1.0.3.tar.gz;
    sha256 = "0kmg1940yiqfm4vpifyj680283ids4nsij9s750nrshwxiwwbqvg";
  };

  buildInputs = [ qt4 cmake sqlite ];

  meta = with stdenv.lib; {
    description = "A free, open-source Japanese dictionary and kanji lookup tool";
    homepage = https://www.tagaini.net/;
    license = with licenses; [
      /* program */ gpl3Plus
      /* data */ cc-by-sa-30
    ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ vbgl ];
  };
}
