{ stdenv, fetchFromGitHub, libX11, imlib2, giflib, libexif }:

stdenv.mkDerivation rec {
  name = "sxiv-${version}";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "muennich";
    repo = "sxiv";
    rev = "v1.3";
    sha256 = "1p8ya15fb77dwb7x2a0xypxx5gvs8pzcllakvxiib1jh1kgzp868";
  };

  preBuild = ''ln -s config.def.h config.h'';

  buildInputs = [ libX11 imlib2 giflib libexif ];

  prePatch = ''sed -i "s@/usr/local@$out@" Makefile'';

  meta = {
    description = "Simple X Image Viewer";
    homepage = "https://github.com/muennich/sxiv";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };
}
