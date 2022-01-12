{ lib, buildPythonApplication, fetchPypi, matplotlib, procps, pyqt5, python
, pythonPackages, qt5, sphinx, xvfb-run }:

buildPythonApplication rec {
  pname = "flent";
  version = "2.0.1";
  src = fetchPypi {
    inherit pname version;
    sha256 = "300a09938dc2b4a0463c9144626f25e0bd736fd47806a9444719fa024d671796";
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
