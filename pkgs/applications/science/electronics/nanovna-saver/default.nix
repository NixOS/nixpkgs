{
  lib,
  python3,
  fetchFromGitHub,
  fetchpatch,
  qt6,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "nanovna-saver";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "NanoVNA-Saver";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-2vDjAdEL8eNje5bm/1m+Fdi+PCGxpXwpxe2KvlLYB58=";
  };

   nativeBuildInputs = [
    qt6.wrapQtAppsHook
    qt6.qtbase
  ];

  propagatedBuildInputs = with python3.pkgs; [
    cython
    scipy
    pyqt6
    pyserial
    numpy
    setuptools
    setuptools-scm
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

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
    maintainers = with maintainers; [ zaninime tmarkus ];
  };
}
