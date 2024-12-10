{
  lib,
  python3,
  fetchFromGitHub,
  extras ? [ "all" ],
}:

python3.pkgs.buildPythonApplication rec {
  pname = "browsr";
  version = "1.19.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "juftin";
    repo = "browsr";
    rev = "refs/tags/v${version}";
    hash = "sha256-V5B+/zfUlpF0TMTHqzyjapW93/DoJKgbJkTMX2NZyIQ=";
  };

  nativeBuildInputs = with python3.pkgs; [
    hatchling
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs =
    with python3.pkgs;
    [
      art
      click
      pandas
      pillow
      pymupdf
      pyperclip
      rich
      rich-click
      rich-pixels
      textual
      textual-universal-directorytree
    ]
    ++ lib.attrVals extras passthru.optional-dependencies;

  passthru.optional-dependencies = with python3.pkgs; {
    all = [
      pyarrow
      textual-universal-directorytree.optional-dependencies.remote
    ];
    parquet = [
      pyarrow
    ];
    remote = [
      textual-universal-directorytree.optional-dependencies.remote
    ];
  };

  nativeCheckInputs = with python3.pkgs; [
    pytest-textual-snapshot
    pytestCheckHook
  ];

  pythonRelaxDeps = [
    "art"
    "pandas"
    "pymupdf"
    "rich-click"
    "rich-pixels"
    "rich"
    "textual"
  ];

  pythonImportsCheck = [
    "browsr"
  ];

  pytestFlagsArray = [
    "--snapshot-update"
  ];

  disabledTests = [
    # Tests require internet access
    "test_github_screenshot"
    "test_github_screenshot_license"
    "test_textual_app_context_path_github"
    "test_mkdocs_screenshot"
    # Different output
    "test_textual_app_context_path"
  ];

  meta = with lib; {
    description = "A file explorer in your terminal";
    mainProgram = "browsr";
    homepage = "https://juftin.com/browsr";
    changelog = "https://github.com/juftin/browsr/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
