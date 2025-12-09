{
  lib,
  rel,
  buildKodiBinaryAddon,
  fetchFromGitHub,
  pkg-config,
  glm,
  libGL,
  jsoncpp,
}:

buildKodiBinaryAddon rec {
  pname = "visualization-shadertoy";
  namespace = "visualization.shadertoy";
  version = "21.0.2";

  src = fetchFromGitHub {
    owner = "xbmc";
    repo = namespace;
    rev = "${version}-${rel}";
    hash = "sha256-M70WQL4BqFI4LMFLBXlupuXxRkbTqA0OocYlCbY28VQ=";
  };

  extraBuildInputs = [
    pkg-config
    libGL
    jsoncpp
  ];

  propagatedBuildInputs = [ glm ];
  meta = with lib; {
    homepage = "https://github.com/xbmc/visualization.shadertoy";
    description = "Shadertoy visualization for kodi";
    platforms = platforms.all;
    license = licenses.gpl2Only;
    teams = [ teams.kodi ];
  };
}
