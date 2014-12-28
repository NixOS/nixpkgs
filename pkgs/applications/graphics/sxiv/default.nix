{ stdenv, fetchgit, libX11, imlib2, giflib, libexif }:

stdenv.mkDerivation {
  name = "sxiv-1.3-git";

  src = fetchgit {
    url = "https://github.com/muennich/sxiv.git";
    rev = "6216bf6c2d42be63025d29550831d9f4447f4066";
    sha256 = "e25e19cf073cc2621656e50d2c31cc59cc0fc200716f96c765374568a26977f1";
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
