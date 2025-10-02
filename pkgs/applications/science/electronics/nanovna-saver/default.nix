{
  lib,
  stdenv,
  python3,
  fetchFromGitHub,
  qt6,
  writeShellScriptBin,
}:
let
  # Matches the pyside6-uic and pyside6-rcc implementations
  # https://code.qt.io/cgit/pyside/pyside-setup.git/tree/sources/pyside-tools/pyside_tool.py?id=9b310d4c0654a244147766e382834b5e8bdeb762#n90
  pyside-tools-uic = writeShellScriptBin "pyside6-uic" ''
    exec ${qt6.qtbase}/libexec/uic -g python "$@"
  '';
  pyside-tools-rcc = writeShellScriptBin "pyside6-rcc" ''
    exec ${qt6.qtbase}/libexec/rcc -g python "$@"
  '';
in
python3.pkgs.buildPythonApplication rec {
  pname = "nanovna-saver";
  version = "0.7.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NanoVNA-Saver";
    repo = "nanovna-saver";
    tag = "v${version}";
    sha256 = "sha256-Asx4drb9W2NobdgOlbgdm1aAzB69hnIWvOM915F7sgA=";
  };

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
    qt6.qtbase
  ];

  buildInputs = lib.optional stdenv.hostPlatform.isLinux qt6.qtwayland;

  propagatedBuildInputs = with python3.pkgs; [
    cython
    scipy
    pyqt6
    pyserial
    pyside6
    numpy
    setuptools
    setuptools-scm
  ];

  doCheck = false;

  dontWrapGApps = true;
  dontWrapQtApps = true;

  postPatch = ''
    substituteInPlace src/tools/ui_compile.py \
      --replace-fail "pyside6-uic" "${pyside-tools-uic}/bin/pyside6-uic" \
      --replace-fail "pyside6-rcc" "${pyside-tools-rcc}/bin/pyside6-rcc"
  '';

  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      "''${qtWrapperArgs[@]}"
    )
  '';

  meta = with lib; {
    homepage = "https://github.com/NanoVNA-Saver/nanovna-saver";
    description = "Tool for reading, displaying and saving data from the NanoVNA";
    mainProgram = "NanoVNASaver";
    longDescription = ''
      A multiplatform tool to save Touchstone files from the NanoVNA, sweep
      frequency spans in segments to gain more than 101 data points, and
      generally display and analyze the resulting data.
    '';
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      zaninime
      tmarkus
    ];
  };
}
