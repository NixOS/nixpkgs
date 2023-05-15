{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "protonup-qt";
  version = "2.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DavidoTek";
    repo = "ProtonUp-Qt";
    rev = "v${version}";
    hash = "sha256-9N53BmBd+mZ8XG9Igvp8qS9kfiFhQ99OgrDYOTX/wLk=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    inputs
    pyside6
    pyxdg
    pyyaml
    requests
    steam
    vdf
    zstandard
  ];

  meta = with lib; {
    description = "Install and manage GE-Proton, Luxtorpeda & more for Steam and Wine-GE & more for Lutris with this graphical user interface";
    homepage = "https://github.com/DavidoTek/ProtonUp-Qt/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ michaelBelsanti ];
    mainProgram = "protonup-qt";
    platforms = [ "x86_64-linux" ];
  };
}
