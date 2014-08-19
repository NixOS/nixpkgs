{ stdenv, fetchurl, pythonPackages, mopidy }:

pythonPackages.buildPythonPackage rec {
  name = "mopidy-moped-${version}";

  version = "0.3.3";

  src = fetchurl {
    url = "https://github.com/martijnboland/moped/archive/v${version}.tar.gz";
    sha256 = "19f3asqx7wmla53nhrxzdwj6qlkjv2rcwh34jxp27bz7nkhn0ihv";
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
