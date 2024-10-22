{
  lib,
  buildPythonApplication,
  fetchPypi,
  procps,
  python,
  qt5,
  xvfb-run,
}:
buildPythonApplication rec {
  pname = "flent";
  version = "2.1.1";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-21gd6sPYCZll3Q2O7kucTRhXvc5byXeQr50+1bZVT3M=";
  };

  buildInputs = [python.pkgs.sphinx];
  nativeBuildInputs = [qt5.wrapQtAppsHook];
  propagatedBuildInputs = [
    procps
    python.pkgs.matplotlib
    python.pkgs.pyqt5
    python.pkgs.qtpy
  ];
  nativeCheckInputs = [
    python.pkgs.mock
    xvfb-run
  ];

  checkPhase = ''
    # we want the gui tests to always run
    sed -i 's|self.skip|pass; #&|' unittests/test_gui.py

    cat >test-runner <<EOF
    #!/bin/sh
    ${python.pythonOnBuildForHost.interpreter} nix_run_setup test
    EOF
    chmod +x test-runner
    wrapQtApp test-runner --prefix PYTHONPATH : $PYTHONPATH
    xvfb-run -s '-screen 0 800x600x24' ./test-runner
  '';

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "FLExible Network Tester";
    homepage = "https://flent.org";
    license = licenses.gpl3;

    maintainers = [maintainers.mmlb];
  };
}
