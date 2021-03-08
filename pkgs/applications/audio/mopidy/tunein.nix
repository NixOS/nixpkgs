{ lib, stdenv, python3Packages, mopidy }:

python3Packages.buildPythonApplication rec {
  pname = "mopidy-tunein";
  version = "1.0.2";

  src = python3Packages.fetchPypi {
    inherit version;
    pname = "Mopidy-TuneIn";
    sha256 = "1mvfhka8wi835yk9869yn3b6mdkfwqkylp14vpjkbm42d0kj4lkc";
  };

  propagatedBuildInputs = [
    mopidy
  ];

  pythonImportsCheck = [ "mopidy_tunein.tunein" ];

  meta = with lib; {
    description = "Mopidy extension for playing music from tunein";
    homepage = "https://github.com/kingosticks/mopidy-tunein";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
