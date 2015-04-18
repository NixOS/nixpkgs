{ stdenv, fetchurl, pythonPackages, mopidy }:

pythonPackages.buildPythonPackage rec {
  name = "mopidy-moped-${version}";

  version = "0.5.0";

  src = fetchurl {
    url = "https://github.com/martijnboland/moped/archive/v${version}.tar.gz";
    sha256 = "1bkx0c4yi48nxm1vzacdil9scn0ilwkbd1rgiga34p77lcg16qb2";
  };

  propagatedBuildInputs = [ mopidy ];

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/martijnboland/moped;
    description = "A web client for Mopidy";
    license = licenses.mit;
    maintainers = [ maintainers.rickynils ];
    hydraPlatforms = [];
  };
}
