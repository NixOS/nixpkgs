{ lib, fetchFromGitHub, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  name = "morphis-${version}";
  version = "0.8";
  namePrefix = "";

  enableParallelBuilding = true;

  src = fetchFromGitHub {
    owner = "fps";
    repo = "morphis-mirror";
    rev = "f319b81bdb1f03aa30c220c759d48446d1a99009";
    sha256 = "05ldvaqmqn7g7y4hzri94dwb4ghzrxc6b67qz8n8qp8frkskfsh6";
  };

  buildInputs = [ pythonPackages.pbr ];

  propagatedBuildInputs = with pythonPackages; [
    pycrypto
    sqlalchemy9
  ];

  meta = {
    homepage = http://morph.is;
    description = "A distributed datastore";
    maintainers = [ "Florian Paul Schmidt <mista.tapas@gmx.net>" ];
    platforms = lib.platforms.all;
  };
}

