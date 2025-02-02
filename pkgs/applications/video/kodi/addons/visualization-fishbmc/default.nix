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
  pname = "visualization-fishbmc";
  namespace = "visualization.fishbmc";
  version = "20.2.0";

  src = fetchFromGitHub {
    owner = "xbmc";
    repo = namespace;
    rev = "${version}-${rel}";
    hash = "sha256-MgeSIKAy0N2NMGsU/15tKtDb34CROjcMaKjGyySl9Z0=";
  };

  extraBuildInputs = [
    pkg-config
    libGL
  ];

  propagatedBuildInputs = [ glm ];
  meta = with lib; {
    homepage = "https://github.com/xbmc/visualization.fishbmc";
    description = "FishBMC visualization for kodi";
    platforms = platforms.all;
    license = licenses.gpl2Only;
    maintainers = teams.kodi.members;
  };
}
