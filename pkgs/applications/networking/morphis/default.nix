{ lib, fetchFromGitHub, pythonPackages, fetchurl }:

pythonPackages.buildPythonPackage rec {
  name = "morphis-${version}";
  version = "0.8";
  namePrefix = "";

  enableParallelBuilding = true;

  src = fetchFromGitHub {
    owner = "fps";
    repo = "morphis-mirror";
    rev = "88259977d63492475cf28f0305ecaa508f4cefaa";
    sha256 = "15c8wpwz877y5gnqghwiq0cc544mshw8ipwla47i9nk9nmkwq0jr";
  };

  buildInputs = [ pythonPackages.pbr ];

  propagatedBuildInputs = with pythonPackages; [
      pycrypto
      sqlalchemy9
      cython
    ];

  meta = {
    homepage = http://morph.is;
    description = "A distributed datastore";
    maintainers = [ "Florian Paul Schmidt <mista.tapas@gmx.net>" ];
    platforms = lib.platforms.all;
  };
}

