{
  python3,
  version,
  generator-out,
}:
python3.pkgs.buildPythonPackage {
  pname = "nanopb";
  inherit version;
  src = generator-out;
  pyproject = true;
  pythonImportsCheck = [ "nanopb" ];
  propagatedBuildInputs = with python3.pkgs; [
    setuptools
    protobuf
    six
  ];
}
