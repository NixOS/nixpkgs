{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "framework-led-matrix-monitor";
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "timoteuszelle";
    repo = "led-matrix";
    tag = "v${version}";
    hash = "sha256-6JDJCE5DiEUxdoP6xORZgzvrCGBbRTIbdw7hUS1Rxok=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    numpy
    psutil
    pyserial
    evdev
    pynput
  ];

  # No tests available in upstream
  doCheck = false;

  meta = with lib; {
    description = "System monitor for Framework 16 LED matrix modules";
    longDescription = ''
      A Python application that displays real-time system performance
      metrics on Framework 16 laptop LED matrix panels. Shows CPU utilization,
      memory usage, battery status, disk I/O, network activity, temperatures,
      and fan speeds across the left and right LED matrix modules.

      This package includes additional enhancements beyond the original,
      such as a plugin system, NixOS integration, and improved Linux support.
    '';
    homepage = "https://github.com/timoteuszelle/led-matrix";
    changelog = "https://github.com/timoteuszelle/led-matrix/blob/${src.tag}/VERSION.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ timoteuszelle ];
    platforms = lib.platforms.linux;
    mainProgram = "framework-led-matrix-monitor";
  };
}
