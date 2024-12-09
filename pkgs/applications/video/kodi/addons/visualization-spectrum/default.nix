{ lib, rel, buildKodiBinaryAddon, fetchFromGitHub, pkg-config, glm, libGL }:

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

  extraBuildInputs = [ pkg-config libGL ];

  propagatedBuildInputs = [ glm ];
  meta = with lib; {
    homepage = "https://github.com/xbmc/visualization.spectrum";
    description = "Spectrum visualization for kodi";
    platforms = platforms.all;
    license = licenses.gpl2Only;
    maintainers = teams.kodi.members;
  };
}
