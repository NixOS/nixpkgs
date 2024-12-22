{ lib, fetchPypi, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "frida-tools";
  version = "12.5.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vlqBN0E+bpfx+TLliZ3hgCaeOEdMRP/rmAfkmjOTqyA=";
  };

  propagatedBuildInputs = with python3Packages; [
    pygments
    prompt-toolkit
    colorama
    frida-python
  ];

  meta = {
    description = "Dynamic instrumentation toolkit for developers, reverse-engineers, and security researchers (client tools)";
    homepage = "https://www.frida.re/";
    maintainers = with lib.maintainers; [ s1341 ];
    license = lib.licenses.wxWindows;
  };
}
