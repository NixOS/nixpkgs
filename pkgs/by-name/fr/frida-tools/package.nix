{
  lib,
  fetchPypi,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "frida-tools";
  version = "14.4.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-M+iKHoJpxIUUoEVYntL8PPR7B3TbBDiW/Oc8ZE15wo8=";
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
    license = lib.licenses.wxWindows;
  };
}
