{ lib, fetchFromGitHub, python3Packages, wrapQtAppsHook }:

let
  py = python3Packages;
in py.buildPythonApplication rec {
  pname = "friture";
  version = "0.48";

  src = fetchFromGitHub {
    owner = "tlecomte";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-oOH58jD49xAeSuP+l6tYUpwkYsnfeSGTt8x4DFzTY6g=";
  };

  nativeBuildInputs = (with py; [ numpy cython scipy ]) ++
    [ wrapQtAppsHook ];

  propagatedBuildInputs = with py; [
    sounddevice
    pyopengl
    pyopengl-accelerate
    docutils
    numpy
    pyqt5
    appdirs
    pyrr
    rtmixer
  ];

  postPatch = ''
    # Remove version constraints from Python dependencies in setup.py
    sed -i -E "s/\"([A-Za-z0-9]+)(=|>|<)=[0-9\.]+\"/\"\1\"/g" setup.py
  '';

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "A real-time audio analyzer";
    homepage = "https://friture.org/";
    license = licenses.gpl3;
    platforms = platforms.linux; # fails on Darwin
    maintainers = with maintainers; [ laikq alyaeanyx ];
  };
}
