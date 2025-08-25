{
  lib,
  buildPythonPackage,
  fetchPypi,
  python3Packages,
}:

buildPythonPackage rec {
  pname = "isobiscuit";
  version = "0.3.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03ivhmh9ikc51mi2547m0my2fvgicgnnc40lqjgc8g276imfhq13";
  };

  pyproject = true;

  build-system = with python3Packages; [
    poetry-core
    hatchling
  ];

  dependencies = with python3Packages; [
    requests
    pyyaml
    colorama
  ];

  meta = {
    description = "Tool for virtualizing isolated processes";
    homepage = "https://github.com/isobiscuit/isobiscuit";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ trollmii ];
  };
}
