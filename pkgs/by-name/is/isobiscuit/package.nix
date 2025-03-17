{
  lib,
  buildPythonPackage,
  fetchPypi,
  python3Packages,
  ...
}:

buildPythonPackage rec {
  pname = "isobiscuit";
  version = "0.3.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1rhd3gxp8wzvd16hb7yv9p8m842s2vw8s253nx2iqvqrqgm6hbih";
  };

  propagatedBuildInputs = with python3Packages; [
    requests
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
