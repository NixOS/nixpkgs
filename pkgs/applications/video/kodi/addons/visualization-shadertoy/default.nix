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
  version = "20.3.0";

  src = fetchFromGitHub {
    owner = "xbmc";
    repo = namespace;
    rev = "${version}-${rel}";
    hash = "sha256-PaHbEcB4gCC8gUzc7T49msI8f0xa2iXqSaYW/eqD8yw=";
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
    maintainers = teams.kodi.members;
  };
}
