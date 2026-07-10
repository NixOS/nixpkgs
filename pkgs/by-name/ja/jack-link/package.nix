{
  stdenv,
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  pkg-config,
  libjack2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jack-link";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "rncbc";
    repo = "jack_link";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FaFFKcTB70UDWtst7A2JeqzSgVGDkkaRhZS3II56ndU=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libjack2
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    homepage = "https://github.com/rncbc/jack_link";
    description = "jack_link bridges JACK transport with Ableton Link";
    license = lib.licenses.gpl2Plus;
    mainProgram = "jack_link";
    maintainers = with lib.maintainers; [ magnetophon ];
    platforms = lib.platforms.linux;
  };
})
