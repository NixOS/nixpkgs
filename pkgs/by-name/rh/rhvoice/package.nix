{
  lib,
  stdenv,
  fetchFromGitHub,
  ensureNewerSourcesForZipFilesHook,
  pkg-config,
  scons,
  glibmm,
  libpulseaudio,
  libao,
  speechd-minimal,
}:

stdenv.mkDerivation rec {
  pname = "rhvoice";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "RHVoice";
    repo = "RHVoice";
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-eduKnxSTIDTxcW3ExueNxVKf8SjmXkVeTfHvJ0eyBPY=";
  };

  patches = [
    # SConstruct patch
    #     Scons creates an independent environment that assumes standard POSIX paths.
    #     The patch is needed to push the nix environment.
    #     - PATH
    #     - PKG_CONFIG_PATH, to find available (sound) libraries
    #     - RPATH, to link to the newly built libraries
    ./honor_nix_environment.patch
  ];

  nativeBuildInputs = [
    ensureNewerSourcesForZipFilesHook
    pkg-config
    scons
  ];

  buildInputs = [
    glibmm
    libpulseaudio
    libao
    speechd-minimal
  ];

  meta = {
    description = "Free and open source speech synthesizer for Russian language and others";
    homepage = "https://github.com/Olga-Yakovleva/RHVoice/wiki";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ berce ];
    platforms = with lib.platforms; all;
    mainProgram = "RHVoice-test";
  };
}
