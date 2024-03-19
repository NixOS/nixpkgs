{ lib, rel, buildKodiBinaryAddon, fetchFromGitHub, pkg-config, glm, libGL }:

buildKodiBinaryAddon rec {
  pname = "visualization-goom";
  namespace = "visualization.goom";
  version = "20.1.1";

  src = fetchFromGitHub {
    owner = "xbmc";
    repo = namespace;
    rev = "${version}-${rel}";
    hash = "sha256-TxXqJQdPT1+3DwAJv0F2Hfksh+ZV4QjfOnp4/k53GpQ=";
  };

  extraBuildInputs = [ pkg-config libGL ];

  propagatedBuildInputs = [ glm ];
  meta = with lib; {
    homepage = "https://github.com/xbmc/visualization.goom";
    description = "Goom visualization for kodi";
    platforms = platforms.all;
    license = licenses.gpl2Only;
    maintainers = teams.kodi.members;
  };
}
