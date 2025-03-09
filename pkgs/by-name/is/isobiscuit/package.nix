{
  lib,
  buildPythonPackage,
  fetchPypi,
  python3Packages,
  ...
}:

buildPythonPackage rec {
  pname = "isobiscuit";
  version = "0.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0aliv0iljs9ch38jviilhqcmns8qv3y9mgw7kfd269b00zjw8fxq";
  };

  propagatedBuildInputs = with python3Packages; [
    requests
    grpcio
    grpcio-tools
    pyyaml
    colorama
    poetry-core
  ];

  meta = with lib; {
    description = "IsoBiscuit is a tool for virtualization, where processes are running in biscuits.";
    license = licenses.asl20;
    maintainers = with maintainers; [ trollmii ];
  };
}
