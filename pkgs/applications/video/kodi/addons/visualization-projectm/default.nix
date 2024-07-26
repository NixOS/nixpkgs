{ lib, rel, buildKodiBinaryAddon, fetchFromGitHub, pkg-config, glm, libGL, projectm }:

buildKodiBinaryAddon rec {
  pname = "visualization-projectm";
  namespace = "visualization.projectm";
  version = "20.2.0";

  src = fetchFromGitHub {
    owner = "xbmc";
    repo = namespace;
    rev = "${version}-${rel}";
    hash = "sha256-Kcl1ep+RJlofFmxkrGT3T+XXdwiCofq1hggwU0PAd0E=";
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
