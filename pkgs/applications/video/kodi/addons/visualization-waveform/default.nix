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
  pname = "visualization-waveform";
  namespace = "visualization.waveform";
  version = "20.2.1";

  src = fetchFromGitHub {
    owner = "xbmc";
    repo = namespace;
    rev = "${version}-${rel}";
    hash = "sha256-e1SIpMmfnS92X4f114MKch4o9Ke80aIzw6OQPrEb8d0=";
  };

  extraBuildInputs = [
    pkg-config
    libGL
  ];

  propagatedBuildInputs = [ glm ];
  meta = {
    homepage = "https://github.com/xbmc/visualization.waveform";
    description = "Waveform visualization for kodi";
    platforms = lib.platforms.all;
    license = lib.licenses.gpl2Only;
    maintainers = lib.teams.kodi.members;
  };
}
