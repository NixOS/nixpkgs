{ stdenv, fetchurl, pythonPackages, mopidy }:

pythonPackages.buildPythonPackage rec {
  name = "mopidy-moped-${version}";

  version = "0.3.1";

  src = fetchurl {
    url = "https://github.com/martijnboland/moped/archive/v${version}.tar.gz";
    sha256 = "0sjp8vr4yfyjx233gamhg0p67zjnlpc9yq3szbw897igsh23j2yr";
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
