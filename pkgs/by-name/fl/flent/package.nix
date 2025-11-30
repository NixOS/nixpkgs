{
  lib,
  python3Packages,
  fetchPypi,
  procps,
  qt5,
  nix-update-script,
}:
python3Packages.buildPythonApplication rec {
  pname = "flent";
  version = "2.2.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BPwh3oWIY1YEI+ecgi9AUiX4Ka/Y5dYikwmfvvNB+eg=";
  };

  build-system = with python3Packages; [
    setuptools
    sphinx
  ];

  nativeBuildInputs = [ qt5.wrapQtAppsHook ];

  dependencies = with python3Packages; [
    matplotlib
    pyqt5
    qtpy
  ];

  nativeCheckInputs = [ python3Packages.unittestCheckHook ];

  preCheck = ''
    # we want the gui tests to always run
    sed -i 's|self.skip|pass; #&|' unittests/test_gui.py

    # Dummy qt setup for gui tests
    export QT_PLUGIN_PATH="${qt5.qtbase.bin}/${qt5.qtbase.qtPluginPrefix}"
    export QT_QPA_PLATFORM=offscreen
  '';

  preFixup = ''
    makeWrapperArgs+=(
      "''${qtWrapperArgs[@]}"
      --prefix PATH : ${lib.makeBinPath [ procps ]}
    )
  '';

  passthru.updateScript = nix-update-script { };
  meta = {
    description = "FLExible Network Tester";
    homepage = "https://flent.org";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ mmlb ];
    mainProgram = "flent";
    badPlatforms = lib.platforms.darwin;
  };
}
