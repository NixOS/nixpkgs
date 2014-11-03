{ stdenv, fetchgit, libX11, imlib2, giflib, libexif }:

stdenv.mkDerivation rec {
  version = "1.3-git";
  name = "sxiv-${version}";

  src = fetchgit {
    url = "git@github.com:muennich/sxiv.git";
    rev = "f55d9f4283f7133ab5a137fc04ee19d1df62fafb";
    sha256 = "85f734f40fdc837514b72694de12bac92fe130286fa6f1dc374e94d575ca8280";
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
