{
  lib,
  buildPythonPackage,
  fetchPypi,
  python3Packages,
  ...
}:

buildPythonPackage rec {
  pname = "isobiscuit";
  version = "0.2.27.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vdm2nibncjbxn0q0c66fk8jjf8jw3iwd4ba1b5q6b494kmfrnca";
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
