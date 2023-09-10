{ lib
, python3
, fetchFromGitHub
, extras ? [ "all" ]
}:

python3.pkgs.buildPythonApplication rec {
  pname = "browsr";
  version = "1.15.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "juftin";
    repo = "browsr";
    rev = "v${version}";
    hash = "sha256-v3DNk0wNG/TISP609YsVfgOFcr+ZOtdOXrm4j81dtLE=";
  };

  nativeBuildInputs = with python3.pkgs; [
    hatchling
    pythonRelaxDepsHook
    pytestCheckHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
    art
    click
    pandas
    pillow
    pymupdf
    rich
    rich-click
    rich-pixels
    textual
    textual-universal-directorytree
  ] ++ lib.attrVals extras passthru.optional-dependencies;

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

  pythonRelaxDeps = [
    "art"
    "pandas"
    "pymupdf"
    "rich-click"
    "textual"
  ];

  pythonImportsCheck = [ "browsr" ];

  # requires internet access
  disabledTests = [
    "test_github_screenshot"
    "test_github_screenshot_license"
    "test_textual_app_context_path_github"
  ];

  meta = with lib; {
    description = "A file explorer in your terminal";
    homepage = "https://juftin.com/browsr";
    changelog = "https://github.com/juftin/browsr/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
