{ lib, stdenv, buildPythonApplication, fetchPypi, matplotlib, procps, pyqt5, python
, pythonPackages, qt5, sphinx, xvfb_run }:

buildPythonApplication rec {
  pname = "flent";
  version = "2.0.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "8a9c33336f828b4e8621c59ae74e28c33b501a5ba074470041ff6aa897c15ce9";
  };

  buildInputs = [ sphinx ];
  nativeBuildInputs = [ qt5.wrapQtAppsHook ];
  propagatedBuildInputs = [ matplotlib procps pyqt5 ];
  checkInputs = [ procps pythonPackages.mock pyqt5 xvfb_run ];

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
