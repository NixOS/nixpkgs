{
  lib,
  stdenv,
  fetchzip,
}:

stdenv.mkDerivation rec {
  pname = "comic-neue";
  version = "2.51";

  src = fetchzip {
    url = "https://github.com/crozynski/comicneue/releases/download/${version}/comicneue-master.zip";
    hash = "sha256-Xkw+Yd36ffptKsS8RSEP9BPX6eQI7TZn2NgU49rdo80=";
  };

  installPhase = ''
    mkdir -pv $out/share/{doc/${pname}-${version},fonts/{opentype,truetype,WOFF,WOFF2}}
    cp -v {FONTLOG,OFL-FAQ,OFL}.txt $out/share/doc/
    cp -v Booklet-ComicNeue.pdf $out/share/doc/
    cp -v Fonts/OTF/ComicNeue-Angular/*.otf $out/share/fonts/opentype
    cp -v Fonts/OTF/ComicNeue/*.otf $out/share/fonts/opentype
    cp -v Fonts/TTF/ComicNeue-Angular/*.ttf $out/share/fonts/truetype
    cp -v Fonts/TTF/ComicNeue/*.ttf $out/share/fonts/truetype
    cp -v Fonts/WebFonts/*.woff $out/share/fonts/WOFF
    cp -v Fonts/WebFonts/*.woff2 $out/share/fonts/WOFF2
  '';

  meta = with lib; {
    homepage = "http://comicneue.com/";
    description = "Casual type face: Make your lemonade stand look like a fortune 500 company";
    longDescription = ''
      ComicNeue is inspired by Comic Sans but more regular. It was
      designed by Craig Rozynski. It is available in two variants:
      Comic Neue and Comic Neue Angular. The former having round and
      the latter angular terminals. Both variants come in Light,
      Regular, and Bold weights with Oblique variants.
    '';
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
