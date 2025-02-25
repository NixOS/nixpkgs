{
  lib,
  fetchPypi,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "frida-tools";
  version = "13.6.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-imNW0vorY90lp2OkhYLYwgpyW+Vxd1kdq3Lvd4/iNVA=";
  };

  propagatedBuildInputs = with python3Packages; [
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
