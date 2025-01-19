{
  lib,
  rel,
  buildKodiBinaryAddon,
  fetchFromGitHub,
  pkg-config,
  glm,
  libGL,
}:

buildKodiBinaryAddon rec {
  pname = "visualization-spectrum";
  namespace = "visualization.spectrum";
  version = "20.2.0";

  src = fetchFromGitHub {
    owner = "xbmc";
    repo = namespace;
    rev = "${version}-${rel}";
    hash = "sha256-rl6eydHv0g646H7478UQboVp/OrKExQYJOiaVDeDRhE=";
  };

  extraBuildInputs = [
    pkg-config
    libGL
  ];

  propagatedBuildInputs = [ glm ];
  meta = {
    homepage = "https://github.com/xbmc/visualization.spectrum";
    description = "Spectrum visualization for kodi";
    platforms = lib.platforms.all;
    license = lib.licenses.gpl2Only;
    maintainers = lib.teams.kodi.members;
  };
}
