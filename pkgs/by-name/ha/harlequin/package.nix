{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
  glibcLocales,
  withPostgresAdapter ? true,
  withBigQueryAdapter ? true,
}:
let
  # Temporarily use textual 0.82 until harlequin is updated for 0.86
  # https://github.com/NixOS/nixpkgs/issues/364867
  textual_0_82 = (
    python3Packages.textual.overrideAttrs (old: rec {
      version = "0.82.0";

      src = fetchFromGitHub {
        owner = "Textualize";
        repo = "textual";
        rev = "refs/tags/v${version}";
        hash = "sha256-belpoXQ+CkTchK+FjI/Ur8v4cNgzX39xLdNfPCwaU6E=";
      };
      disabledTests = old.disabledTests ++ [
        "test_selection"
      ];
    })
  );
in
python3Packages.buildPythonApplication rec {
  pname = "harlequin";
  version = "1.25.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tconbeer";
    repo = "harlequin";
    rev = "refs/tags/v${version}";
    hash = "sha256-ov9pMvFzJAMfOM7JeSgnp6dZ424GiRaH7W5OCKin9Jk=";
  };

  pythonRelaxDeps = [
    "textual"
    "numpy"
  ];

  build-system = with python3Packages; [ poetry-core ];

  nativeBuildInputs = [ glibcLocales ];

  dependencies =
    with python3Packages;
    [
      click
      duckdb
      importlib-metadata
      numpy
      packaging
      platformdirs
      questionary
      rich-click
      sqlfmt
      textual_0_82
      (textual-fastdatatable.override {
        textual = textual_0_82;
      })
      (
        (textual-textarea.override {
          textual = textual_0_82;
        }).overrideAttrs
        (_: {
          disabledTestPaths = [ "tests/functional_tests" ];
        })
      )
      tomlkit
    ]
    ++ lib.optionals withPostgresAdapter [ harlequin-postgres ]
    ++ lib.optionals withBigQueryAdapter [ harlequin-bigquery ];

  pythonImportsCheck = [
    "harlequin"
    "harlequin_duckdb"
    "harlequin_sqlite"
    "harlequin_vscode"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  nativeCheckInputs =
    [
      versionCheckHook
    ]
    ++ (with python3Packages; [
      pytest-asyncio
      pytestCheckHook
    ]);

  disabledTests = [
    # Tests require network access
    "test_connect_extensions"
    "test_connect_prql"
  ];

  disabledTestPaths = [
    # Tests requires more setup
    "tests/functional_tests/"
  ];

  meta = {
    description = "The SQL IDE for Your Terminal";
    homepage = "https://harlequin.sh";
    changelog = "https://github.com/tconbeer/harlequin/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "harlequin";
    maintainers = with lib.maintainers; [ pcboy ];
    platforms = lib.platforms.unix;
  };
}
