{ lib, pythonPackages, fetchurl }:

pythonPackages.buildPythonPackage rec {
  name = "morphis-${version}";
  version = "0.8";
  namePrefix = "";

  src = fetchurl {
    url = "https://morph.is/v${version}/morphis-${version}.tar.xz";
    sha256 = "1wpxh5fhj8nx4yx4cvmc087cnf4iqwxf7zd7rdh2ln3pgxrjfral";
  };

  buildInputs = [ pythonPackages.pbr ];

  propagatedBuildInputs = with pythonPackages; [
      pycrypto
      sqlalchemy
    ];

  meta = {
    homepage = http://morph.is;
    description = "A distributed datastore";
    maintainers = [ "Florian Paul Schmidt <mista.tapas@gmx.net>" ];
    platforms = lib.platforms.all;
  };
}

