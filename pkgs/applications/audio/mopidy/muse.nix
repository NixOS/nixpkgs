{ lib, pythonPackages, mopidy }:

pythonPackages.buildPythonApplication rec {
  pname = "mopidy-muse";
  version = "0.0.27";

  src = pythonPackages.fetchPypi {
    inherit version;
    pname = "Mopidy-Muse";
    sha256 = "0jx9dkgxr07avzz9zskzhqy98zsxkdrf7iid2ax5vygwf8qsx8ks";
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
    maintainers = with maintainers; [ hexa ];
  };
}
