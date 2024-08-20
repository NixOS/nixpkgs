{ lib, stdenv, fetchFromGitLab, pkg-config, meson, ninja, cmake
, git, criterion, gtk3, libconfig, gnuplot, opencv, json-glib
, fftwFloat, cfitsio, gsl, exiv2, librtprocess, wcslib, ffmpeg
, libraw, libtiff, libpng, libjpeg, libheif, ffms, wrapGAppsHook3
, curl
}:

stdenv.mkDerivation rec {
  pname = "siril";
  version = "1.2.3";

  src = fetchFromGitLab {
    owner = "free-astro";
    repo = "siril";
    rev = version;
    hash = "sha256-JUMk2XHMOeocSpeeI+k3s9TsEQCdqz3oigTzuwRHbT4=";
  };

  nativeBuildInputs = [
    meson ninja cmake pkg-config git criterion wrapGAppsHook3
  ];

  buildInputs = [
    gtk3 cfitsio gsl exiv2 gnuplot opencv fftwFloat librtprocess wcslib
    libconfig libraw libtiff libpng libjpeg libheif ffms ffmpeg json-glib
    curl
  ];

  # Necessary because project uses default build dir for flatpaks/snaps
  dontUseMesonConfigure = true;
  dontUseCmakeConfigure = true;

  # Meson fails to find libcurl unless the option is specifically enabled
  configureScript = ''
    ${meson}/bin/meson setup -Denable-libcurl=yes --buildtype release nixbld .
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
