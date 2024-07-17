{
  lib,
  pythonPackages,
  fetchPypi,
  mopidy,
}:

pythonPackages.buildPythonApplication rec {
  pname = "mopidy-muse";
  version = "0.0.33";

  src = fetchPypi {
    inherit version;
    pname = "Mopidy-Muse";
    sha256 = "sha256-CEPAPWtMrD+HljyqBB6EAyGVeOjzkvVoEywlE4XEJGs=";
  };

  propagatedBuildInputs = [
    mopidy
    pythonPackages.pykka
  ];

  pythonImportsCheck = [ "mopidy_muse" ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "Mopidy web client with Snapcast support";
    homepage = "https://github.com/cristianpb/muse";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
