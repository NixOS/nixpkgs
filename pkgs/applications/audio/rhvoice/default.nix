{ lib
, stdenv
, fetchFromGitHub
, ensureNewerSourcesForZipFilesHook
, pkg-config
, scons
, glibmm
, libpulseaudio
, libao
, speechd
}:

stdenv.mkDerivation rec {
  pname = "rhvoice";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "RHVoice";
    repo = "RHVoice";
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-G5886rjBaAp0AXcr07O0q7K1OXTayfIbd4zniKwDiLw=";
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
    speechd
  ];

  meta = {
    description = "A free and open source speech synthesizer for Russian language and others";
    homepage = "https://github.com/Olga-Yakovleva/RHVoice/wiki";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ berce ];
    platforms = with lib.platforms; all;
  };
}
