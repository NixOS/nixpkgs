{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "sqlitebiter";
  version = "0.36.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "thombashi";
    repo = "sqlitebiter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-u/CDQP66r10c2fwIhaam9aBrz1BC7g+g9IjlZ70qsrE=";
  };

  postPatch = ''
    substituteInPlace requirements/requirements.txt \
      --replace-fail "path>=13,<17" "path>=13"
    substituteInPlace sqlitebiter/__main__.py \
      --replace-fail ".isfile()" ".is_file()" \
      --replace-fail ".isdir()" ".is_dir()"
    substituteInPlace sqlitebiter/converter/_file.py \
      --replace-fail ".isfile()" ".is_file()" \
      --replace-fail "file_path.ext" "file_path.suffix"

    # Remove pytest plugin options that require pytest-discord/pytest-md-report
    substituteInPlace pyproject.toml \
      --replace-fail "md_report = true" "" \
      --replace-fail "md_report_verbose = 0" "" \
      --replace-fail "md_report_color = \"auto\"" "" \
      --replace-fail "discord_verbose = 1" ""
  '';

  build-system = with python3Packages; [ setuptools ];

  dependencies =
    with python3Packages;
    [
      appconfigpy
      click
      envinfopy
      loguru
      msgfy
      nbformat
      path
      pathvalidate
      pytablereader
      retryrequests
      simplesqlite
      tcolorpy
      typepy
    ]
    ++ pytablereader.optional-dependencies.excel
    ++ pytablereader.optional-dependencies.md;

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pytablewriter
    responses
    sqliteschema
    xlsxwriter
  ];

  pythonImportsCheck = [ "sqlitebiter" ];

  meta = {
    description = "CLI tool to convert various data formats to SQLite database files";
    homepage = "https://github.com/thombashi/sqlitebiter";
    changelog = "https://github.com/thombashi/sqlitebiter/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yajo ];
  };
})
