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
  libX11,
  sdl2-compat,
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
  curlMinimal,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "snis";
  version = "1.0.9";

  src = fetchFromGitHub {
    owner = "smcameron";
    repo = "space-nerds-in-space";
    tag = "v${finalAttrs.version}";
    hash = "sha256-H6ZeZOeKy8Z5HGicQs9CmjR2tDzD8AGvLr75Xx0YkAg=";
  };

  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "OPUSARCHIVE=libopus.a" "OPUSARCHIVE=" \
      --replace-fail "-I./opus-1.3.1/include" "-I${libopus.dev}/include/opus"
    substituteInPlace snis_text_to_speech.sh \
      --replace-fail "pico2wave" "${sox}/bin/pico2wave" \
      --replace-fail "espeak" "${espeak-classic}/bin/espeak" \
      --replace-fail "aplay" "${alsa-utils}/bin/aplay" \
      --replace-fail "play" "${sox}/bin/play" \
      --replace-fail "/bin/rm" "${coreutils}/bin/rm"
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
    libX11
    sdl2-compat
    lua5_2
    glew
    openssl
    picotts
    sox
    alsa-utils
    libopus
    libxcrypt-legacy
    curlMinimal
  ];

  makeFlags = [ "PREFIX=$(out)" ];
  buildFlags = [
    "all"
    "models"
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Space Nerds In Space, a multi-player spaceship bridge simulator";
    homepage = "https://smcameron.github.io/space-nerds-in-space/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pentane ];
    platforms = platforms.linux;
    mainProgram = "snis_launcher";
  };
})
