{
  lib,
  fetchPypi,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "frida-tools";
  version = "14.8.2";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "frida_tools";
    hash = "sha256-qXdbwwW4QMwqVRC/Xn9XDc82qETOp76FwoFH22Z4nZ0=";
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
})
