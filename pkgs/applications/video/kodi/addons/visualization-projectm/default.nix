{ lib, rel, buildKodiBinaryAddon, fetchFromGitHub, pkg-config, glm, libGL, projectm }:

buildKodiBinaryAddon rec {
  pname = "visualization-projectm";
  namespace = "visualization.projectm";
  version = "21.0.1";

  src = fetchFromGitHub {
    owner = "xbmc";
    repo = namespace;
    rev = "${version}-${rel}";
    hash = "sha256-wjSQmOtQb4KjY3iH3Xh7AdQwE6ked+cpW6/gdNYS+NA=";
  };

  extraBuildInputs = [ pkg-config libGL projectm ];

  propagatedBuildInputs = [ glm ];
  meta = with lib; {
    homepage = "https://github.com/xbmc/visualization.projectm";
    description = "Projectm visualization for kodi";
    platforms = platforms.all;
    license = licenses.gpl2Only;
    maintainers = teams.kodi.members;
  };
}
