{ lib, buildKodiAddon, fetchFromGitHub, controller }:
buildKodiAddon rec {
  pname = "game-controller-${controller}";
  namespace = "game.controller.${controller}";
  version = "1.0.3";

  sourceDir = "addons/" + namespace;

  src = fetchFromGitHub {
    owner = "kodi-game";
    repo = "kodi-game-controllers";
    rev = "01acb5b6e8b85392b3cb298b034aadb1b24ccf18";
    sha256 = "0sbc0w0fwbp7rbmbgb6a1kglhnn5g85hijcbbvf5x6jdq9v3f1qb";
  };

  meta = with lib; {
    description = "Add support for different gaming controllers.";
    platforms = platforms.all;
    license = licenses.odbl;
    maintainers = teams.kodi.members;
  };
}
