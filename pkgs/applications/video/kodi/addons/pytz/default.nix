{ lib, buildKodiAddon, fetchFromGitHub, addonUpdateScript }:

buildKodiAddon rec {
  pname = "pytz";
  namespace = "script.module.pytz";
  version = "v2014.2";

  src = fetchFromGitHub {
    owner = "powlo";
    repo = "script.module.pytz";
    rev = "0057604553d205b0cb586f646f92673efce7e7b7";
    hash = "sha256-NEMlBgeX2ignIGo21BzkN8QYdyYzUUwY3Tko9fY8xow=";
  };

  passthru = {
    pythonPath = "lib";
  };

  meta = with lib; {
    homepage = "https://github.com/powlo/script.module.pytz";
    description = "XBMC script wrapper around pytz";
    license = licenses.mit;
    maintainers = teams.kodi.members;
  };
}
