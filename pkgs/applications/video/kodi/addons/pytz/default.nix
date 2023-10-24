{ lib, buildKodiAddon, fetchzip, addonUpdateScript }:

buildKodiAddon rec {
  pname = "pytz";
  namespace = "script.module.pytz";
  version = "2023.3.0+matrix.1";

  src = fetchzip {
    url =
      "https://mirrors.kodi.tv/addons/matrix/${namespace}/${namespace}-${version}.zip";
    sha256 = "sha256-GNUdxFetiuYUOvzOXS8oQwxIyUF7Y2q8lV/UftqVvQs=";
  };

  passthru = { pythonPath = "lib"; };

  meta = with lib; {
    homepage = "https://github.com/powlo/script.module.pytz";
    description = "XBMC script wrapper around pytz";
    license = licenses.mit;
    maintainers = teams.kodi.members;
  };
}
