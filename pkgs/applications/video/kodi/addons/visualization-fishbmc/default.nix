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
  meta = {
    homepage = "https://github.com/xbmc/visualization.fishbmc";
    description = "FishBMC visualization for kodi";
    platforms = lib.platforms.all;
    license = lib.licenses.gpl2Only;
    maintainers = lib.teams.kodi.members;
  };
}
