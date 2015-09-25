{ lib, fetchFromGitHub, pythonPackages, fetchurl }:

pythonPackages.buildPythonPackage rec {
    name = "morphis-${version}";
    version = "0.8";
    namePrefix = "";

    enableParallelBuilding = true;

    src = fetchFromGitHub {
        owner = "fps";
        repo = "morphis-mirror";
        rev = "135ac9d8101d03c83a90e6b635640c3db68190c6";
        sha256 = "15rhjx3zlxdpyc82gpkbp0dsafcf6p734q61nywj6yx68i8jsnjn";
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

