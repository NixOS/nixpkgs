{
  lib,
  buildPythonPackage,
  fetchPypi,
  python3Packages,
  ...
}:

buildPythonPackage rec {
  pname = "isobiscuit";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bdimhz7jzjj1jiz9gvl8vwrm1il1ja08n0j1g22an7s3gx10n32";
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
