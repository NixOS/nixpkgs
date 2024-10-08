{
  lib,
  python3Packages,
  fetchFromGitHub,
  harlequin,
  testers,
  nix-update-script,
  versionCheckHook,
  withPostgresAdapter ? true,
  withBigQueryAdapter ? true,
}:
python3Packages.buildPythonApplication rec {
  pname = "harlequin";
  version = "1.24.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tconbeer";
    repo = "harlequin";
    rev = "refs/tags/v${version}";
    hash = "sha256-3Rb47zkWsC6RJhk1btQc/kwxpFFWVnxY2PJooHB7IzQ=";
  };

  build-system = with python3Packages; [
    poetry-core
  ];

  dependencies =
    with python3Packages;
    [
      textual
      textual-fastdatatable
      textual-textarea
      click
      rich-click
      duckdb
      sqlfmt
      platformdirs
      importlib-metadata
      tomlkit
      questionary
      numpy
      packaging
    ]
    ++ lib.optionals withPostgresAdapter [ harlequin-postgres ]
    ++ lib.optionals withBigQueryAdapter [ harlequin-bigquery ];

  pythonRelaxDeps = [
    "textual"
  ];

  pythonImportsCheck = [
    "harlequin"
    "harlequin_duckdb"
    "harlequin_sqlite"
    "harlequin_vscode"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  nativeCheckInputs = [
    versionCheckHook
  ];

  meta = {
    description = "The SQL IDE for Your Terminal";
    homepage = "https://harlequin.sh";
    mainProgram = "harlequin";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pcboy ];
    platforms = lib.platforms.unix;
    changelog = "https://github.com/tconbeer/harlequin/releases/tag/v${version}";
  };
}
