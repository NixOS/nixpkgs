{
  lib,
  stdenv,
  fetchFromGitHub,
  testers,
  cmake,
  pkg-config,
  gitUpdater,
  soundtouch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "avisynthplus";
  version = "3.7.5";

  src = fetchFromGitHub {
    owner = "AviSynth";
    repo = "AviSynthPlus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RkEZWsAKZABtl+SbRLCjMqyQoi9ainbaI9hWlpO6Fwo=";
  };

  patchPhase = ''
    substituteInPlace ./avs_core/avisynth_conf.h.in \
        --replace-fail '@CORE_PLUGIN_INSTALL_PATH@' '/run/current-system/sw/lib'
  '';

  buildInputs = [
    soundtouch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  outputs = [
    "out"
    "dev"
  ];

  passthru = {
    updateScript = gitUpdater { rev-prefix = "v"; };
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = with lib; {
    description = "Improved version of the AviSynth frameserver";
    homepage = "https://avs-plus.net/";
    changelog = "https://github.com/AviSynth/AviSynthPlus/releases/tag/${finalAttrs.src.rev}";
    license = licenses.gpl2Only;
    pkgConfigModules = [ "avisynth" ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ jopejoe1 ];
  };
})
