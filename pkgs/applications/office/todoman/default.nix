{ lib
, python3
, glibcLocales
, installShellFiles
, jq
}:
let
  inherit (python3.pkgs) buildPythonApplication fetchPypi setuptools-scm;
in
buildPythonApplication rec {
  pname = "todoman";
  version = "4.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4c4d0c6533da8d553f3dd170c9c4ff3752eb11fd7177ee391414a39adfef60ad";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    installShellFiles
    setuptools-scm
  ];

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

  checkInputs = with python3.pkgs; [
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
    "test_default_command"
    "test_main"
    "test_missing_cache_dir"
    "test_sorting_null_values"
    "test_xdg_existant"
  ];

  pythonImportsCheck = [
    "todoman"
  ];

  meta = with lib; {
    homepage = "https://github.com/pimutils/todoman";
    description = "Standards-based task manager based on iCalendar";
    longDescription = ''
      Todoman is a simple, standards-based, cli todo (aka: task) manager. Todos
      are stored into icalendar files, which means you can sync them via CalDAV
      using, for example, vdirsyncer.

      Todos are read from individual ics files from the configured directory.
      This matches the vdir specification.  There’s support for the most common TODO
      features for now (summary, description, location, due date and priority) for
      now.  Runs on any Unix-like OS. It’s been tested on GNU/Linux, BSD and macOS.
      Unsupported fields may not be shown but are never deleted or altered.

      Todoman is part of the pimutils project
    '';
    license = licenses.isc;
    maintainers = with maintainers; [ leenaars ];
    platforms = platforms.linux;
  };
}
