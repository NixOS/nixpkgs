{
  lib,
  stdenv,
  fetchFromGitHub,
  glibcLocales,
  installShellFiles,
  jq,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "todoman";
  version = "4.4.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pimutils";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-5tQaNT6QVN9mxa9t6OvMux4ZGy4flUqszTAwet2QL0w=";
  };

  nativeBuildInputs =
    [
      installShellFiles
    ]
    ++ (with python3.pkgs; [
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
    pytest-cov-stub
  ];

  LC_ALL = "en_US.UTF-8";

  postInstall = ''
    installShellCompletion --bash contrib/completion/bash/_todo
    substituteInPlace contrib/completion/zsh/_todo --replace "jq " "${lib.getExe jq} "
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

  meta = {
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
    changelog = "https://todoman.readthedocs.io/en/stable/changelog.html#v${
      builtins.replaceStrings [ "." ] [ "-" ] version
    }";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [
      leenaars
      antonmosich
    ];
    mainProgram = "todo";
  };
}
