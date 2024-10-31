{ lib, stdenv, fetchzip }:

stdenv.mkDerivation rec {
  pname = "comic-neue";
  version = "2.51";

  src = fetchzip {
    url = "http://comicneue.com/${pname}-${version}.zip";
    sha256 = "sha256-DjRZtFnJOtZnxhfpgU5ihZFAonRK608/BQztCAExIU0=";
    stripRoot = false; # because it comes with a __MACOSX directory
  };

  installPhase = ''
    mkdir -pv $out/share/{doc/${pname}-${version},fonts/{opentype,truetype,WOFF,WOFF2}}
    cp -v ${pname}-${version}/{FONTLOG,OFL-FAQ,OFL}.txt $out/share/doc/
    cp -v ${pname}-${version}/Booklet-ComicNeue.pdf $out/share/doc/
    cp -v ${pname}-${version}/OTF/ComicNeue-Angular/*.otf $out/share/fonts/opentype
    cp -v ${pname}-${version}/OTF/ComicNeue/*.otf $out/share/fonts/opentype
    cp -v ${pname}-${version}/TTF/ComicNeue-Angular/*.ttf $out/share/fonts/truetype
    cp -v ${pname}-${version}/TTF/ComicNeue/*.ttf $out/share/fonts/truetype
    cp -v ${pname}-${version}/WebFonts/*.woff $out/share/fonts/WOFF
    cp -v ${pname}-${version}/WebFonts/*.woff2 $out/share/fonts/WOFF2
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
    maintainers = [ maintainers.AndersonTorres ];
  };
}
