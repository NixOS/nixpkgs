{
  config,
  lib,
  stdenv,
  fetchurl,
  zlib,
  pkg-config,
  mpg123,
  libogg,
  libvorbis,
  portaudio,
  libsndfile,
  flac,
  usePulseAudio ? config.pulseaudio or stdenv.hostPlatform.isLinux,
  libpulseaudio,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libopenmpt";
  version = "0.8.4";

  outputs = [
    "out"
    "dev"
    "bin"
  ];

  src = fetchurl {
    url = "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-${finalAttrs.version}+release.autotools.tar.gz";
    hash = "sha256-Yn+b8RqsrmFaHyyYLH6IyyHxGy1vAmeUb3yCxerklDs=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    zlib
    mpg123
    libogg
    libvorbis
    portaudio
    libsndfile
    flac
  ]
  ++ lib.optionals usePulseAudio [
    libpulseaudio
  ];

  configureFlags = [
    (lib.strings.withFeature usePulseAudio "pulseaudio")
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  postFixup = ''
    moveToOutput share/doc $dev
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Cross-platform C++ and C library to decode tracked music files into a raw PCM audio stream";
    mainProgram = "openmpt123";
    longDescription = ''
      libopenmpt is a cross-platform C++ and C library to decode tracked music files (modules) into a raw PCM audio stream.
      openmpt123 is a cross-platform command-line or terminal based module file player.
      libopenmpt is based on the player code of the OpenMPT project.
    '';
    homepage = "https://lib.openmpt.org/libopenmpt/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ OPNA2608 ];
    platforms = lib.platforms.unix;
  };
})
