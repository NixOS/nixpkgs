{ lib, rel, buildKodiBinaryAddon, fetchFromGitHub, pkg-config, glm, libGL }:

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

  extraBuildInputs = [ pkg-config libGL ];

  propagatedBuildInputs = [ glm ];
  meta = with lib; {
    homepage = "https://github.com/xbmc/visualization.matrix";
    description = "Matrix visualization for kodi";
    platforms = platforms.all;
    license = licenses.gpl2Only;
    maintainers = teams.kodi.members;
  };
}
