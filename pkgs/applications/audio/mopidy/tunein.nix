{ stdenv, python3Packages, mopidy }:

python3Packages.buildPythonApplication rec {
  pname = "mopidy-tunein";
  version = "1.0.0";

  src = python3Packages.fetchPypi {
    inherit version;
    pname = "Mopidy-TuneIn";
    sha256 = "0insasf4w8ajsqjh5zmax7pkzmrk1p245vh4y8ddicldj45p6qfj";
  };

  propagatedBuildInputs = [
    mopidy
  ];

  # tests fail with "ValueError: Namespace Gst not available" in mopidy itself
  doCheck = false;

  pythonImportsCheck = [ "mopidy_tunein.tunein" ];

  meta = with stdenv.lib; {
    description = "Mopidy extension for playing music from tunein.";
    homepage = "https://github.com/kingosticks/mopidy-tunein";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
