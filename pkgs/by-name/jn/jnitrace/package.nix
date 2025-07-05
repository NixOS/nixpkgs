{
  lib,
  fetchPypi,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "jnitrace";
  version = "3.3.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-b8azmlYbNEFSUN3MjqpUqNlBTKT0JTLpCVBkk9Rx7+0=";
  };

  dependencies = with python3Packages; [
    frida-python
    colorama
    hexdump
    setuptools
  ];

  meta = {
    description = "Frida based tool that traces usage of the JNI API in Android apps";
    homepage = "https://github.com/chame1eon/jnitrace";
    maintainers = [ lib.maintainers.axka ];
    license = lib.licenses.mit;
    mainProgram = "jnitrace";
  };
}
