{
  lib,
  python3,
  fetchFromGitHub,
  wrapQtAppsHook,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "nanovna-saver";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "NanoVNA-Saver";
    repo = pname;
    rev = "v${version}";
    sha256 = "1n1bh46spdyk7kgvv95hyfy9f904czhzlvk41vliqkak56hj2ss1";
  };

  nativeBuildInputs = [ wrapQtAppsHook ];

  propagatedBuildInputs = with python3.pkgs; [
    cython
    scipy
    pyqt5
    pyserial
    numpy
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
    longDescription = ''
      A multiplatform tool to save Touchstone files from the NanoVNA, sweep
      frequency spans in segments to gain more than 101 data points, and
      generally display and analyze the resulting data.
    '';
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ zaninime ];
  };
}
