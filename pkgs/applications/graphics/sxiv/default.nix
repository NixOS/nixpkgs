{ stdenv, fetchgit, libX11, imlib2, giflib, libexif }:

stdenv.mkDerivation {
  name = "sxiv-1.3-git";

  src = fetchgit {
    url = "https://github.com/muennich/sxiv.git";
    rev = "92e3b57816e999b46f8d0778984719227631e9a7";
    sha256 = "0jbswh0k1xq5hgrv1pyvk7lpwbbj66p7gjsdm8zh6ah324apjr2b";
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
