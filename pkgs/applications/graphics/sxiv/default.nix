{ stdenv, fetchgit, libX11, imlib2, giflib, libexif }:

stdenv.mkDerivation {
  name = "sxiv-1.3-git";

  src = fetchgit {
    url = "https://github.com/muennich/sxiv.git";
    rev = "54af451b4a81b5b1072f27de0981a2d39cabc2d6";
    sha256 = "1b0fb6bd8d36af4c7f1160fcc12b5b7382546c7da35b4924d259f7efaa4c97d0";
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
