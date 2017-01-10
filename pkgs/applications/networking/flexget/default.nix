{ lib
, pythonPackages
, fetchurl
, transmission
, deluge
, config
}:

with pythonPackages;

buildPythonPackage rec {
  version = "1.2.337";
  name = "FlexGet-${version}";
  disabled = isPy3k;

  src = fetchurl {
    url = "mirror://pypi/F/FlexGet/${name}.tar.gz";
    sha256 = "0f7aaf0bf37860f0c5adfb0ba59ca228aa3f5c582131445623a4c3bc82d45346";
  };

  doCheck = false;

  buildInputs = [ nose ];
  propagatedBuildInputs = [
    paver feedparser sqlalchemy pyyaml rpyc
    beautifulsoup_4_1_3 html5lib_0_9999999 pyrss2gen pynzb progressbar jinja2 flask
    cherrypy requests dateutil_2_1 jsonschema python_tvrage tmdb3
    guessit pathpy apscheduler ]
  # enable deluge and transmission plugin support, if they're installed
  ++ lib.optional (config.deluge or false) deluge
  ++ lib.optional (transmission != null) transmissionrpc;

  meta = {
    homepage = http://flexget.com/;
    description = "Multipurpose automation tool for content like torrents";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ domenkozar ];
  };
}