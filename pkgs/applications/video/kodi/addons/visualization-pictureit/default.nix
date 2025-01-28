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
  pname = "visualization-pictureit";
  namespace = "visualization.pictureit";
  version = "21.0.1";

  src = fetchFromGitHub {
    owner = "xbmc";
    repo = namespace;
    rev = "${version}-${rel}";
    hash = "sha256-0soMNqff/aVANDFORL3mqUUpi2BWmauUtE4EBr3QwlI=";
  };

  extraBuildInputs = [
    pkg-config
    libGL
  ];

  propagatedBuildInputs = [ glm ];
  meta = with lib; {
    homepage = "https://github.com/xbmc/visualization.pictureit";
    description = "PictureIt visualization for kodi";
    platforms = platforms.all;
    license = licenses.gpl2Only;
    maintainers = teams.kodi.members;
  };
}
