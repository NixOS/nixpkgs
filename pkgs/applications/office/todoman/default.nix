{ lib
, stdenv
, fetchFromGitHub
, glibcLocales
, installShellFiles
, jq
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "todoman";
  version = "4.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "pimutils";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-MItFZ+4Q7UKeIWHl8KFiWOLNgFcfb0h1YWjPd+g48Wg=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    installShellFiles
  ] ++ (with python3.pkgs; [
    setuptools-scm
  ]);

  propagatedBuildInputs = with python3.pkgs; [
    atomicwrites
    click
    click-log
    click-repl
    humanize
    icalendar
    parsedatetime
    python-dateutil
    pyxdg
    tabulate
    urwid
  ];

  nativeCheckInputs = with python3.pkgs; [
    flake8
    flake8-import-order
    freezegun
    hypothesis
    pytestCheckHook
    glibcLocales
  ];

  LC_ALL = "en_US.UTF-8";

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace " --cov=todoman --cov-report=term-missing" ""
  '';

  postInstall = ''
    installShellCompletion --bash contrib/completion/bash/_todo
    substituteInPlace contrib/completion/zsh/_todo --replace "jq " "${jq}/bin/jq "
    installShellCompletion --zsh contrib/completion/zsh/_todo
  '';

  disabledTests = [
    # Testing of the CLI part and output
    "test_color_due_dates"
    "test_color_flag"
    "test_datetime_serialization"  # Will be fixed in versions after 4.1.0
    "test_default_command"
    "test_main"
    "test_missing_cache_dir"
    "test_sorting_null_values"
    "test_xdg_existant"
    # Tests are sensitive to performance
    "test_sorting_fields"
  ];

  pythonImportsCheck = [
    "todoman"
  ];

  meta = with lib; {
    homepage = "https://github.com/pimutils/todoman";
    description = "Standards-based task manager based on iCalendar";
    longDescription = ''
      Todoman is a simple, standards-based, cli todo (aka task) manager. Todos
      are stored into iCalendar files, which means you can sync them via CalDAV
      using, for example, vdirsyncer.

      Todos are read from individual ics files from the configured directory.
      This matches the vdir specification. There is support for the most common TODO
      features for now (summary, description, location, due date and priority) for
      now.
      Unsupported fields may not be shown but are never deleted or altered.
    '';
    changelog = "https://github.com/pimutils/todoman/raw/v${version}/CHANGELOG.rst";
    license = licenses.isc;
    maintainers = with maintainers; [ leenaars ];
  };
}
