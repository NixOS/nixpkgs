{ lib, stdenv, fetchFromGitLab, fetchFromGitHub, pkg-config, meson, ninja,
  git, criterion, wrapGAppsHook, gtk3, libconfig, gnuplot, opencv,
  fftwFloat, cfitsio, gsl, exiv2, curl, librtprocess, ffmpeg,
  libraw, libtiff, libpng, libjpeg, libheif, ffms
}:

stdenv.mkDerivation rec {
  pname = "siril";
  version = "0.99.6";

  src = fetchFromGitLab {
    owner = "free-astro";
    repo = pname;
    rev = version;
    sha256 = "06vh8x45gv0gwlnqjwxglf12jmpdaxkiv5sixkqh20420wabx3ha";
  };

  nativeBuildInputs = [
    meson ninja pkg-config git criterion wrapGAppsHook
  ];

  buildInputs = [
    gtk3 cfitsio gsl exiv2 gnuplot curl opencv fftwFloat librtprocess
    libconfig libraw libtiff libpng libjpeg libheif ffms ffmpeg
  ];

  # Necessary because project uses default build dir for flatpaks/snaps
  dontUseMesonConfigure = true;

  configureScript = ''
    ${meson}/bin/meson --buildtype release nixbld .
  '';

  postConfigure = ''
    cd nixbld
  '';

  meta = with lib; {
    homepage = "https://www.siril.org/";
    description = "Astronomical image processing tool";
    license = licenses.gpl3;
    maintainers = with maintainers; [ hjones2199 ];
    platforms = [ "x86_64-linux" ];
  };
}
