{
  lib,
  fetchPypi,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "frida-tools";
  version = "14.5.0";
  format = "pyproject";

  src = fetchPypi {
    inherit version;
    pname = "frida_tools";
    hash = "sha256-Wdjx0NDGojpaycHcgXp+UiBsiAoR3V3UaWw9948HWZ0=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  pythonRelaxDeps = [
    "frida"
    "websockets"
  ];

  dependencies = with python3Packages; [
    pygments
    prompt-toolkit
    colorama
    frida-python
    websockets
  ];

  meta = {
    description = "Dynamic instrumentation toolkit for developers, reverse-engineers, and security researchers (client tools)";
    homepage = "https://www.frida.re/";
    maintainers = with lib.maintainers; [ s1341 ];
    license = with lib.licenses; [
      lgpl2Plus
      wxWindowsException31
    ];
  };
}
