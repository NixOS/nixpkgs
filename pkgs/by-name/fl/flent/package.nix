{
  lib,
  python3Packages,
  fetchPypi,
  procps,
  qt5,
  xvfb-run,
}:
python3Packages.buildPythonApplication rec {
  pname = "flent";
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BPwh3oWIY1YEI+ecgi9AUiX4Ka/Y5dYikwmfvvNB+eg=";
  };

  build-system = [ python3Packages.sphinx ];

  nativeBuildInputs = [ qt5.wrapQtAppsHook ];

  dependencies = with python3Packages; [
    matplotlib
    pyqt5
    qtpy
  ];

  nativeCheckInputs = [
    python3Packages.mock
    xvfb-run
  ];

  checkPhase = ''
    runHook preCheck

    # we want the gui tests to always run
    sed -i 's|self.skip|pass; #&|' unittests/test_gui.py

    export XDG_RUNTIME_DIR=$(mktemp -d)
    export HOME=$(mktemp -d)
    cat >test-runner <<EOF
    #!/bin/sh
    ${python3Packages.python.interpreter} -m unittest discover
    EOF
    chmod +x test-runner
    wrapQtApp test-runner --prefix PYTHONPATH : $PYTHONPATH
    xvfb-run -s '-screen 0 800x600x24' ./test-runner

    runHook postCheck
  '';

  preFixup = ''
    makeWrapperArgs+=(
      "''${qtWrapperArgs[@]}"
      --prefix PATH : ${lib.makeBinPath [ procps ]}
    )
  '';

  meta = {
    description = "FLExible Network Tester";
    homepage = "https://flent.org";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ mmlb ];
    mainProgram = "flent";
  };
}
