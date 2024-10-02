{
  lib,
  alsa-lib,
  cmake,
  fetchFromGitHub,
  glib,
  pkg-config,
  pkgsMusl,
  stdenv,
  # Boolean flags
  logToStderr ? true,
  tracingSupport ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "apulse";
  version = "0.1.13";

  src = fetchFromGitHub {
    name = "apulse-source-${finalAttrs.version}";
    owner = "i-rinat";
    repo = "apulse";
    rev = "v${finalAttrs.version}";
    hash = "sha256-tlLdUyyajtnXAJXUuK4n5PWFRu9RM9jb+XjsApWBztw=";
  };

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    glib
  ];

  cmakeFlags = [
    (lib.cmakeBool "LOG_TO_STDERR" logToStderr)
    (lib.cmakeBool "WITH_TRACE" tracingSupport)
  ];

  strictDeps = true;

  passthru = {
    tests = {
      apulse-musl = pkgsMusl.apulse;
    };
  };

  meta = {
    homepage = "https://github.com/i-rinat/apulse";
    description = "PulseAudio emulation for ALSA";
    longDescription = ''
      The program provides an alternative partial implementation of the
      PulseAudio API. It consists of a loader script and a number of shared
      libraries with the same names as from original PulseAudio, so applications
      could dynamically load them and think they are talking to PulseAudio.
      Internally, no separate sound mixing daemon is used. Instead, apulse
      relies on ALSA's dmix, dsnoop, and plug plugins to handle multiple sound
      sources and capture streams running at the same time. dmix plugin muxes
      multiple playback streams; dsnoop plugin allow multiple applications to
      capture from a single microphone; and plug plugin transparently converts
      audio between various sample formats, sample rates and channel
      numbers. For more than a decade now, ALSA comes with these plugins enabled
      and configured by default.

      apulse wasn't designed to be a drop-in replacement of PulseAudio. It's
      pointless, since that will be just reimplementation of original
      PulseAudio, with the same client-daemon architecture, required by the
      complete feature set. Instead, only parts of the API that are crucial to
      specific applications are implemented. That's why there is a loader
      script, named apulse. It updates value of LD_LIBRARY_PATH environment
      variable to point also to the directory where apulse's libraries are
      installed, making them available to the application.
    '';
    license = lib.licenses.mit;
    mainProgram = "apulse";
    maintainers = with lib.maintainers; [
      AndersonTorres
      jagajaga
    ];
    platforms = lib.platforms.linux;
  };
})
