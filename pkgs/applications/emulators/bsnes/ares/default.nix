{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, wrapGAppsHook
, SDL2
, alsa-lib
, gtk3
, gtksourceview3
, libGL
, libGLU
, libX11
, libXv
, libao
, libpulseaudio
, openal
, udev
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ares";
  version = "130.1";

  src = fetchFromGitHub {
    owner = "ares-emulator";
    repo = "ares";
    rev = "v${finalAttrs.version}";
    hash = "sha256-q2wDpbNaDyKPBL20FDaHScKQEJYstlQdJ4CzbRoSPlk=";
  };

  patches = [
    ./000-dont-rebuild-on-install.patch
    ./001-fix-ruby.patch
  ];

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    SDL2
    alsa-lib
    gtk3
    gtksourceview3
    libGL
    libGLU
    libX11
    libXv
    libao
    libpulseaudio
    openal
    udev
  ];

  enableParallelBuilding = true;

  makeFlags = [
    "hiro=gtk3"
    "local=false"
    "openmp=true"
    "prefix=$(out)"
    "-C desktop-ui"
  ];

  meta = with lib; {
    homepage = "https://ares-emu.net";
    description = "Open-source multi-system emulator with a focus on accuracy and preservation";
    license = licenses.isc;
    maintainers = with maintainers; [ Madouura AndersonTorres ];
    platforms = platforms.linux;
  };
})
# TODO: select between Qt, GTK2 and GTK3
# TODO: support Darwin
