{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "beeref";
  version = "2024-06-02";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rbreu";
    repo = "beeref";
    rev = "caed5c38016c9efea05f78d3f60178e0ba878cd4";
    hash = "sha256-wA0cqJgyirAqpZYoWjzSTiGX4FraTHXLCLWm2kALWn4=";
  };

  patches = [
    ./pyproject.toml.patch
  ];

  nativeBuildInputs = with python3.pkgs; [
    setuptools
  ];

  propagatedBuildInputs = with python3.pkgs; [
    exif
    lxml
    pyqt6
    rectangle-packer
  ];

  meta = with lib; {
    description = "A Simple Reference Image Viewer";
    homepage = "https://beeref.org/";
    changelog = "https://github.com/rbreu/beeref/blob/main/CHANGELOG.rst";
    license = licenses.gpl3;
    maintainers = with maintainers; [ wchresta ];
  };
}
