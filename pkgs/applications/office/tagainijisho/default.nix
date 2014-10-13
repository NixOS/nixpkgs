{stdenv, fetchurl, qt4, cmake, sqlite}:

let
  jmdict = fetchurl {
    url = ftp://ftp.monash.edu.au/pub/nihongo/JMdict.gz;
    sha256 = "0ml25hlbi0zifx0i03lkmnkar0dr94401j95j493401c71d4kjlf";
  };
  kanjidic2 = fetchurl {
    url = http://www.csse.monash.edu.au/~jwb/kanjidic2/kanjidic2.xml.gz;
    sha256 = "0v7x10isn0vsrya987dh6l54czgprp2nd7kbxblnnf3g6n31qbgv";
  };
  kanjivg = fetchurl {
    url = https://github.com/KanjiVG/kanjivg/releases/download/r20140816/kanjivg-20140816.xml.gz;
    sha256 = "0wp43xlpfq3p983047mz0j250xpb4wzqxgp8c6ldqjg7s6bzd4h9";
  };
in

stdenv.mkDerivation {
  name = "tagainijisho-1.0.2";
  src = fetchurl {
    url = https://github.com/Gnurou/tagainijisho/archive/1.0.2.tar.gz;
    sha256 = "1h8rf1zph8mpq0mfwil9dnjfwg49xd0bysllcddmkshs5xxv96ca";
  };

  buildInputs = [ qt4 cmake sqlite ];

  preConfigure = ''
    mkdir 3rdparty
    zcat ${jmdict} > 3rdparty/JMdict
    zcat ${kanjidic2} > 3rdparty/kanjidic2.xml
    zcat ${kanjivg} > 3rdparty/kanjivg.xml
  '';

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
