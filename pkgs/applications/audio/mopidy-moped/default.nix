{ stdenv, fetchurl, pythonPackages, mopidy }:

pythonPackages.buildPythonApplication rec {
  name = "mopidy-moped-${version}";
  version = "0.6.0";

  src = fetchurl {
    url = "https://github.com/martijnboland/moped/archive/v${version}.tar.gz";
    sha256 = "0xff8y1kc7rwwsd7ppgbvywf6i8lchjwbxjisfl1kmilwsb166yr";
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
