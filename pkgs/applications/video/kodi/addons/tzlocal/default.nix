{ lib, buildKodiAddon, fetchzip, addonUpdateScript, tzdata, backports-zoneinfo
}:

buildKodiAddon rec {
  pname = "tzlocal";
  namespace = "script.module.tzlocal";
  version = "5.0.1";

  src = fetchzip {
    url =
      "https://mirrors.kodi.tv/addons/nexus/${namespace}/${namespace}-${version}.zip";
    sha256 = "sha256-hYpatEV62sBO59qSlVx0GeUhWFs4M5IVlxo6zQ76FG4=";
  };

  propagatedBuildInputs = [ tzdata backports-zoneinfo ];

  passthru = {
    pythonPath = "lib";
  };

  meta = with lib; {
    homepage = "https://github.com/regebro/tzlocal";
    description =
      "A Python module that tries to figure out what your local timezone is";
    license = licenses.mit;
    maintainers = teams.kodi.members;
  };
}
