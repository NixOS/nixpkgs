{
  lib,
  python3,
  fetchFromGitHub,
  fetchpatch,
  wrapQtAppsHook,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "nanovna-saver";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "NanoVNA-Saver";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-CLfgDQt2rOXtWwvEhlXEstPp28nFhuhiAPYL6EjZVu4=";
  };

  # Fix for https://github.com/NanoVNA-Saver/nanovna-saver/issues/579
  # Try dropping the patch in the next release after v0.5.4
  patches = [
    (fetchpatch {
      name = "remote-changelog-from-setup-py.patch";
      url = "https://github.com/NanoVNA-Saver/${pname}/commit/d654ea0441939e4e1c599d1333b587a185394fbe.diff";
      sha256 = "sha256-ifOhiWD0EYyQZRKp2W3G6crmWslca+/21APmhpfP/xE=";
    })
  ];

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
    maintainers = with maintainers; [ zaninime tmarkus ];
  };
}
