{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "pysunspec2";
  version = "1.1.9";

  disabled = python3.pkgs.pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9cTfT/Fa0w98x56TOSaGscJR2i0dsEU0WL3VwmESw/s=";
  };

  build-system = [ python3.pkgs.setuptools ];

  pythonImportsCheck = [ "sunspec2" ];

  meta = with lib; {
    description = "SunSpec Python library for interfacing with SunSpec devices.";
    homepage = "https://github.com/sunspec/pysunspec2";
    license = licenses.asl20;
    maintainers = [ cheriimoya ];
  };
}
