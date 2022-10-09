{ python39Packages
, fetchFromGitHub
, lib
}:

# Doesn't work with python 3.10 due to behavior change of extension interface.
# https://github.com/rbreu/beeref/issues/54
with python39Packages;
buildPythonApplication rec {
  pname = "beeref";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "rbreu";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zlb+ukPMoahwQTCWq2sq5dQveqLQLtn3pKuq+0AIqho=";
  };

  prePatch = ''
    # Relax install dependency requirements
    substituteInPlace setup.py \
      --replace "pyQt6>=6.1,<=6.1.1" "pyQt6" \
      --replace "pyQt6-Qt6>=6.1,<=6.1.1" ""
  '';

  preCheck = ''
    export HOME=$TMPDIR
  '';

  checkInputs = [ httpretty pytest ];

  propagatedBuildInputs = [
    setuptools
    pyqt6
    exif
    rectangle-packer
  ];

  meta = with lib; {
    homepage = "https://beeref.org/";
    description = "A Simple Reference Image Viewer";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ sifmelcara ];
  };
}
