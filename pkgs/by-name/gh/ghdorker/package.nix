{ lib
, python3
, fetchPypi
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ghdorker";
  version = "0.3.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wF4QoXxH55SpdYgKLHf4sCwUk1rkCpSdnIX5FvFi/BU=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    ghapi
    glom
    python-dotenv
    pyyaml
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "GHDorker"
  ];

  meta = with lib; {
    description = "Extensible GitHub dorking tool";
    mainProgram = "ghdorker";
    homepage = "https://github.com/dtaivpp/ghdorker";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
