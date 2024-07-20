{ lib, rel, buildKodiBinaryAddon, fetchFromGitHub, pkg-config, glm, libGL }:

buildKodiBinaryAddon rec {
  pname = "screensaver-asteroids";
  namespace = "screensaver.asteroids";
  version = "20.2.0";

  src = fetchFromGitHub {
    owner = "xbmc";
    repo = namespace;
    rev = "${version}-${rel}";
    hash = "sha256-Qf8841yh3lZmoVlevzGRAAWloFAXb/RzLmeE5BCfPVM=";
};

  extraBuildInputs = [ pkg-config glm libGL ];

  meta = with lib; {
    homepage = "https://github.com/xbmc/screensaver.asteroids";
    description = "A screensaver that plays Asteroids";
    platforms = platforms.all;
    license = licenses.gpl2Only;
    maintainers = teams.kodi.members;
  };
}
