{ stdenv, fetchgit, libX11, imlib2, giflib, libexif }:

stdenv.mkDerivation {
  name = "sxiv-2015.03.25";

  src = fetchgit {
    url = "https://github.com/muennich/sxiv.git";
    rev = "01ed483b50f506fcba928af43e2ca017897e7c77";
    sha256 = "18s64l3dvibqg9biznzy4mdkkn9qmmpqxpdx7ljx7c0832aqy94k";
  };

  postUnpack = ''
    substituteInPlace $sourceRoot/Makefile \
      --replace /usr/local $out
  '';

  buildInputs = [ libX11 imlib2 giflib libexif ];
  meta = {
    description = "Simple X Image Viewer";
    homepage = "https://github.com/muennich/sxiv";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };
}
