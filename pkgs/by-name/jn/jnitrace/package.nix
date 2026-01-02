{
  lib,
  fetchPypi,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "jnitrace";
  version = "3.3.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-b8azmlYbNEFSUN3MjqpUqNlBTKT0JTLpCVBkk9Rx7+0=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    frida-python
    colorama
    hexdump
    setuptools # pkg_resources is imported during runtime
  ];

  pythonImportsCheck = [ "jnitrace" ];

  meta = {
    description = "Frida based tool that traces usage of the JNI API in Android apps";
    homepage = "https://github.com/chame1eon/jnitrace";
    maintainers = [ lib.maintainers.axka ];
    license = lib.licenses.mit;
    mainProgram = "jnitrace";
  };
}
