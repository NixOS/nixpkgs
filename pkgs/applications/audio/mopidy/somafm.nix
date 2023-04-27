{ lib, python3Packages, mopidy }:

python3Packages.buildPythonApplication rec {
  pname = "mopidy-somafm";
  version = "2.0.2";

  src = python3Packages.fetchPypi {
    inherit version;
    pname = "Mopidy-SomaFM";
    sha256 = "DC0emxkoWfjGHih2C8nINBFByf521Xf+3Ks4JRxNPLM=";
  };

  propagatedBuildInputs = [ mopidy ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://www.mopidy.com/";
    description = "Mopidy extension for playing music from SomaFM";
    license = licenses.mit;
    maintainers = [ maintainers.nickhu ];
  };
}

