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
  pname = "visualization-goom";
  namespace = "visualization.goom";
  version = "21.0.2";

  src = fetchFromGitHub {
    owner = "xbmc";
    repo = namespace;
    rev = "${version}-${rel}";
    hash = "sha256-TGSYSrQLFrjbp+UMQ14f5sb8thePFZaSH7x/ckLIoqw=";
  };

  extraBuildInputs = [
    pkg-config
    libGL
  ];

  propagatedBuildInputs = [ glm ];
  meta = {
    homepage = "https://github.com/xbmc/visualization.goom";
    description = "Goom visualization for kodi";
    platforms = lib.platforms.all;
    license = lib.licenses.gpl2Only;
    teams = [ lib.teams.kodi ];
  };
}
