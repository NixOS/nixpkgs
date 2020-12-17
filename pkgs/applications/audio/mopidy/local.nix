{ lib
, mopidy
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "Mopidy-Local";
  version = "3.2.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "14f78sb3wkg83dg3xcqlq77dh059zzcwry5l9ilyhnmvmyrkhqx0";
  };

  propagatedBuildInputs = [
    mopidy
    python3Packages.uritools
  ];

  checkInputs = [
    python3Packages.pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://github.com/mopidy/mopidy-local";
    description = "Mopidy extension for playing music from your local music archive";
    license = licenses.asl20;
    maintainers = with maintainers; [ ruuda ];
  };
}
