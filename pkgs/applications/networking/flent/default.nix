{ lib, buildPythonApplication, fetchPypi, matplotlib, procps, pyqt5, python
, pythonPackages, qt5, sphinx, xvfb-run }:

buildPythonApplication rec {
  pname = "flent";
  version = "2.1.1";
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-21gd6sPYCZll3Q2O7kucTRhXvc5byXeQr50+1bZVT3M=";
  };

  buildInputs = [ sphinx ];
  nativeBuildInputs = [ qt5.wrapQtAppsHook ];
  propagatedBuildInputs = [ matplotlib procps pyqt5 ];
  checkInputs = [ procps pythonPackages.mock pyqt5 xvfb-run ];

  checkPhase = ''
    cat >test-runner <<EOF
    #!/bin/sh

    ${python.pythonForBuild.interpreter} nix_run_setup test
    EOF
    chmod +x test-runner
    wrapQtApp test-runner --prefix PYTHONPATH : $PYTHONPATH
    xvfb-run -s '-screen 0 800x600x24' ./test-runner
  '';

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "The FLExible Network Tester";
    homepage = "https://flent.org";
    license = licenses.gpl3;

    maintainers = [ maintainers.mmlb ];
  };
}
