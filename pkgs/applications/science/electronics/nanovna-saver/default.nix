{
  lib,
  stdenv,
  python3,
  fetchFromGitHub,
  qt6,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "nanovna-saver";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "NanoVNA-Saver";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-fAVsjknhLhsrGdHu2Q6JWLoFoxZoc+wDCNja+ySCsR4=";
  };

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
    qt6.qtbase
  ];

  buildInputs = lib.optional stdenv.isLinux qt6.qtwayland;

  propagatedBuildInputs = with python3.pkgs; [
    cython
    scipy
    pyqt6
    pyserial
    numpy
    setuptools
    setuptools-scm
  ];

  doCheck = false;

  dontWrapGApps = true;
  dontWrapQtApps = true;

  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      "''${qtWrapperArgs[@]}"
    )
  '';

  meta = with lib; {
    homepage = "https://github.com/NanoVNA-Saver/nanovna-saver";
    description =
      "A tool for reading, displaying and saving data from the NanoVNA";
    mainProgram = "NanoVNASaver";
    longDescription = ''
      A multiplatform tool to save Touchstone files from the NanoVNA, sweep
      frequency spans in segments to gain more than 101 data points, and
      generally display and analyze the resulting data.
    '';
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ zaninime tmarkus ];
  };
}
