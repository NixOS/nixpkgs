{
  python3Packages,
  fetchFromGitHub,
  lib,
}:

with python3Packages;
buildPythonApplication rec {
  pname = "beeref";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "rbreu";
    repo = "beeref";
    rev = "v${version}";
    hash = "sha256-GtxiJKj3tlzI1kVXzJg0LNAUcodXSna17ZvAtsAEH4M=";
  };

  prePatch = ''
    # Relax install dependency requirements
    substituteInPlace setup.py \
      --replace "pyQt6>=6.5.0,<=6.6.1" "pyQt6" \
      --replace "pyQt6-Qt6>=6.5.0,<=6.6.1" ""
  '';

  propagatedBuildInputs = [
    exif
    lxml
    pyqt6
    rectangle-packer
  ];

  # Writeable home directory needed for tests
  preCheck = ''
    export HOME=$TMPDIR
  '';
  checkInputs = [
    httpretty
    pytest
  ];

  meta = with lib; {
    description = "A reference image viewer";
    homepage = "https://beeref.org/";
    longDescription = ''
      BeeRef lets you quickly arrange your reference images and view them while you create. Its minimal interface is designed not to get in the way of your creative process.
    '';
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ annaaurora ];
    mainProgram = "beeref";
  };
}
