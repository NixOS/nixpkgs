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
  pname = "visualization-matrix";
  namespace = "visualization.matrix";
  version = "20.2.0";

  src = fetchFromGitHub {
    owner = "xbmc";
    repo = namespace;
    rev = "${version}-${rel}";
    hash = "sha256-tojzPqt6VMccveqnhkl0yXS+/fLdxotmQO3jdtYlkFk=";
  };

  extraBuildInputs = [
    pkg-config
    libGL
  ];

  propagatedBuildInputs = [ glm ];
  meta = {
    homepage = "https://github.com/xbmc/visualization.matrix";
    description = "Matrix visualization for kodi";
    platforms = lib.platforms.all;
    license = lib.licenses.gpl2Only;
    teams = [ lib.teams.kodi ];
  };
}
