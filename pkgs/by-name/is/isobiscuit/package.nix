{
  lib,
  buildPythonPackage,
  fetchPypi,
  python3Packages,
  ...
}:

buildPythonPackage rec {
  pname = "isobiscuit";
  version = "0.3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fi2kxf64igzqayldbpsk1rhs9jz14wp3kwps1swnl3n6my4i1y9";
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
