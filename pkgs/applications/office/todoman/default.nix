{ lib
, stdenv
, fetchFromGitHub
, glibcLocales
, installShellFiles
, jq
, python3
, fetchpatch
}:

python3.pkgs.buildPythonApplication rec {
  pname = "todoman";
  version = "4.3.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pimutils";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-dxyI9ypZZBouTUF72wzvi7j+CeoQ9JNSiXrVeV7ForY=";
  };

  patches = [
    (fetchpatch {
      name = "disable-broken-urwid-test.patch";
      url = "https://github.com/pimutils/todoman/commit/7ff0d2e2e69e24df5d66fecc58f8cd0b4e5ced6d.patch";
      hash = "sha256-MMNnnIthNqobexd8GaA6lYxzv5gr1l0e9YK+Ygeje2w=";
    })
  ];

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
    pytest-cov
  ];

  LC_ALL = "en_US.UTF-8";

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
    maintainers = with maintainers; [ leenaars antonmosich ];
    mainProgram = "todo";
  };
}
