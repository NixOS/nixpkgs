{ stdenv, buildPythonApplication, fetchPypi, matplotlib, procps, pyqt5, python
, pythonPackages, qt5, sphinx, xvfb_run }:

buildPythonApplication rec {
  pname = "flent";
  version = "1.3.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "099779i0ghjd9ikq77z6m6scnlmk946lw9issrgz8zm7babiw4d7";
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

  postInstall = ''
    for program in $out/bin/*; do
      wrapQtApp $program --prefix PYTHONPATH : $PYTHONPATH
    done
  '';

  meta = with stdenv.lib; {
    description = "The FLExible Network Tester";
    homepage = "https://flent.org";
    license = licenses.gpl3;

    maintainers = [ maintainers.mmlb ];
  };
}
