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

stdenv.mkDerivation rec {
  pname = "ares";
  version = "129";

  src = fetchFromGitHub {
    owner = "ares-emulator";
    repo = "ares";
    rev = "v${version}";
    sha256 = "sha256-prfvoGtbnsl/1ahx98jBOgT64W566GoUtE8rIOF7lYc=";
  };

  patches = [
    ./dont-rebuild-on-install.patch
    ./fix-ruby.patch
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
    "-C desktop-ui"
    "local=false"
    "openmp=true"
    "hiro=gtk3"
    "prefix=$(out)"
  ];

  meta = with lib; {
    homepage = "https://ares.dev";
    description = "Open-source multi-system emulator with a focus on accuracy and preservation";
    license = licenses.isc;
    maintainers = with maintainers; [ Madouura ];
    platforms = platforms.linux;
  };
}
# TODO: select between Qt, GTK2 and GTK3
# TODO: support Darwin
