{
  lib,
  python3Packages,
  fetchFromGitHub,

  # tests
  xandikos,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "plann";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PyCalendar";
    repo = "plann";
    tag = "v${finalAttrs.version}";
    hash = "sha256-guZBzrI0OUt7SvDcVlyol7/8iti8uG4RjnOFyMHxR9w=";
  };

  build-system = with python3Packages; [
    click
    hatch-vcs
    hatchling
  ];

  dependencies = with python3Packages; [
    caldav
    calendaring-config
    click
    dateparser
    icalendar
    icalendar-searcher
    python-dateutil
    pyyaml
    sortedcontainers
  ];

  optional-dependencies = with python3Packages; {
    dev = [
      deptry
      niquests
      pytest-cov
    ];
  };

  pythonImportsCheck = [
    "plann"
  ];

  # required for tests to start the xandikos server under darwin
  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = with python3Packages; [
    aiohttp
    pytest-cov-stub
    pytestCheckHook
    xandikos
  ];

  meta = {
    description = "Command-line interface to calendars";
    longDescription = ''
      Plann is a command-line CalDAV client, making it possible to add calendar
      events, browse an agenda and do task management.
    '';
    homepage = "https://github.com/PyCalendar/plann";
    changelog = "https://github.com/PyCalendar/plann/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    mainProgram = "plann";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
  };
})
