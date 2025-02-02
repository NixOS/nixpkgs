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
  version = "20.2.0";

  src = fetchFromGitHub {
    owner = "xbmc";
    repo = namespace;
    rev = "${version}-${rel}";
    hash = "sha256-mQDPjpsxStU01H2XJKnX183KAHG+O1CH8JOmApMmwMc=";
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
