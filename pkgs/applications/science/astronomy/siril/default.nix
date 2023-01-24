{ lib, stdenv, fetchFromGitLab, pkg-config, meson, ninja
, git, criterion, gtk3, libconfig, gnuplot, opencv, json-glib
, fftwFloat, cfitsio, gsl, exiv2, librtprocess, wcslib, ffmpeg
, libraw, libtiff, libpng, libjpeg, libheif, ffms, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "siril";
  version = "1.0.6";

  src = fetchFromGitLab {
    owner = "free-astro";
    repo = pname;
    rev = version;
    sha256 = "sha256-KFCA3fUMVFHmh1BdKed5/dkq0EeYcmoWec97WX9ZHUc=";
  };

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
    changelog = "https://gitlab.com/free-astro/siril/-/blob/HEAD/ChangeLog";
    maintainers = with maintainers; [ hjones2199 ];
    platforms = platforms.linux;
  };
}
