{ lib, stdenv, fetchFromGitLab, fetchpatch, pkg-config, meson, ninja
, git, criterion, gtk3, libconfig, gnuplot, opencv, json-glib
, fftwFloat, cfitsio, gsl, exiv2, librtprocess, wcslib, ffmpeg
, libraw, libtiff, libpng, libjpeg, libheif, ffms, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "siril";
  version = "0.99.8.1";

  src = fetchFromGitLab {
    owner = "free-astro";
    repo = pname;
    rev = version;
    sha256 = "0h3slgpj6zdc0rwmyr9zb0vgf53283hpwb7h26skdswmggsk90i5";
  };

  patches = [
    # Backport fix for broken build on glib-2.68
    (fetchpatch {
      url = "https://gitlab.com/free-astro/siril/-/commit/d319fceca5b00f156e1c5e3512d3ac1f41beb16a.diff";
      sha256 = "00lq9wq8z48ly3hmkgzfqbdjaxr0hzyl2qwbj45bdnxfwqragh5m";
    })
  ];

  nativeBuildInputs = [
    meson ninja pkg-config git criterion wrapGAppsHook
  ];

  buildInputs = [
    gtk3 cfitsio gsl exiv2 gnuplot opencv fftwFloat librtprocess wcslib
    libconfig libraw libtiff libpng libjpeg libheif ffms ffmpeg json-glib
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
    description = "Astrophotographic image processing tool";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ hjones2199 ];
    platforms = [ "x86_64-linux" ];
  };
}
