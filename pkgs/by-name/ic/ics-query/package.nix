{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "ics-query";
  version = "0.5.34";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PyCalendar";
    repo = "ics-query";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lVMR8+KHPlvFifjU/zJ7AGmWUQXooeh4t4VFZQo/G28=";
  };

  postPatch = ''
    # If we don't replace {commit_hash}, `hatch-vcs` will attempt to call
    # `git rev-parse` and fail. It's simpler for us to substitute it here.
    substituteInPlace pyproject.toml \
      --replace-fail \
        'source_archive = "https://github.com/niccokunzmann/ics-query/archive/{commit_hash}.zip"' \
        'source_archive = "https://github.com/niccokunzmann/ics-query/archive/${finalAttrs.src.rev}.zip"'
  '';

  build-system = with python3Packages; [
    hatch-vcs
    hatchling
  ];

  dependencies = with python3Packages; [
    click
    icalendar
    python-dateutil
    recurring-ical-events
    six
    tzdata
    tzlocal
    x-wr-timezone
  ];

  pythonRelaxDeps = [
    "icalendar"
    "click"
    "recurring-ical-events"
    "tzdata"
    "tzlocal"
  ];

  pythonImportsCheck = [
    "ics_query"
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  pytestFlags = [
    # By default, pytest will look for `ics-query` in PATH.
    #
    # So, we can either add it there in `preCheck`, or we could just point it
    # at the executable from the $out.
    #
    # See: https://github.com/PyCalendar/ics-query/blob/main/conftest.py
    "--binary=${placeholder "out"}/bin/ics-query"
  ];

  preCheck = ''
    cd ics_query
  '';

  meta = {
    description = "CLI tool to query and filter `.ics` calendar files";
    homepage = "https://ics-query.readthedocs.io/en/stable";
    changelog = "https://github.com/PyCalendar/ics-query/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    mainProgram = "ics-query";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
  };
})
