{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  coreutils,
  portaudio,
  libbsd,
  libpng,
  libvorbis,
  SDL2,
  makeWrapper,
  lua5_2,
  glew,
  openssl,
  picotts,
  alsa-utils,
  espeak-classic,
  sox,
  libopus,
  openscad,
  libxcrypt-legacy,
}:

stdenv.mkDerivation {
  pname = "snis_launcher";
  version = "2024-08-02";

  src = fetchFromGitHub {
    owner = "smcameron";
    repo = "space-nerds-in-space";
    rev = "1dadfca31513561cf95f1229af34341bd1a1bb2a";
    sha256 = "sha256-Qi4lbq1rsayMdRWMAF44K2DNtlZxNUyjnO6kXCW5QhA=";
  };

  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace Makefile \
      --replace "OPUSARCHIVE=libopus.a" "OPUSARCHIVE=" \
      --replace "-I./opus-1.3.1/include" "-I${libopus.dev}/include/opus"
    substituteInPlace snis_text_to_speech.sh \
      --replace "pico2wave" "${sox}/bin/pico2wave" \
      --replace "espeak" "${espeak-classic}/bin/espeak" \
      --replace "play" "${sox}/bin/play" \
      --replace "aplay" "${alsa-utils}/bin/aplay" \
      --replace "/bin/rm" "${coreutils}/bin/rm"
  '';

  nativeBuildInputs = [
    pkg-config
    openscad
    makeWrapper
  ];

  buildInputs = [
    coreutils
    portaudio
    libbsd
    libpng
    libvorbis
    SDL2
    lua5_2
    glew
    openssl
    picotts
    sox
    alsa-utils
    libopus
    libxcrypt-legacy
  ];

  makeFlags = [ "PREFIX=$(out)" ];
  buildFlags = [
    "all"
    "models"
  ];

  meta = with lib; {
    description = "Space Nerds In Space, a multi-player spaceship bridge simulator";
    homepage = "https://smcameron.github.io/space-nerds-in-space/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ alyaeanyx ];
    platforms = platforms.linux;
  };
}
