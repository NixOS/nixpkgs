{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "regolith-rofication";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "regolith-linux";
    repo = "regolith-rofication";
    tag = "v${version}";
    hash = "sha256-Bn57hHuW1yGxBBSiqXCIAbhB5ayY9TvZ8Mfn8I47y8E=";
  };

  dependencies = with python3.pkgs; [
    dbus-python
    pygobject3
  ];

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  pythonImportsCheck = [ "rofication" ];

  meta = {
    description = "Notification system that provides a Rofi front-end";
    homepage = "https://github.com/regolith-linux/regolith-rofication";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ sandptel ];
    mainProgram = "rofication-daemon";
  };
}
