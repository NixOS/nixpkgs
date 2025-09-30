{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "ical2orgpy";
  version = "0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ical2org-py";
    repo = "ical2org.py";
    tag = version;
    hash = "sha256-vBi1WYXMuDFS/PnwFQ/fqN5+gIvtylXidfZklyd6LcI=";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    click
    icalendar
    pytz
    tzlocal
    recurring-ical-events
  ];

  pythonRemoveDeps = [ "future" ];

  nativeCheckInputs = with python3Packages; [
    freezegun
    pytestCheckHook
    pyyaml
    versionCheckHook
  ];

  pythonImportsCheck = [ "ical2orgpy" ];

  meta = {
    changelog = "https://github.com/ical2org-py/ical2org.py/blob/${src.tag}/CHANGELOG.rst";
    description = "Converting ICAL file into org-mode format";
    homepage = "https://github.com/ical2org-py/ical2org.py";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ StillerHarpo ];
    mainProgram = "ical2orgpy";
  };

}
