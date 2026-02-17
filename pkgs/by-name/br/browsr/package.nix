{
  lib,
  python3Packages,
  fetchFromGitHub,
  fetchpatch,
  extras ? [ "all" ],
}:

python3Packages.buildPythonApplication rec {
  pname = "browsr";
  version = "1.22.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "juftin";
    repo = "browsr";
    tag = "v${version}";
    hash = "sha256-eISOADs++ZF62qkWbhFZu6JkEVtTytg3q5nbwS2m+8g=";
  };

  patches = [
    # https://github.com/juftin/browsr/pull/55
    (fetchpatch {
      name = "textual-6-compat.patch";
      url = "https://github.com/juftin/browsr/commit/ab958ac982e14e836a0e44080a53c920ad50b256.patch";
      hash = "sha256-vAJ+M6Eg7N2NV7Cb2DWPYqLJIeq/DY1COECEQOnkpXE=";
    })
  ];

  build-system = with python3Packages; [
    hatchling
  ];

  dependencies =
    with python3Packages;
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
    ++ lib.attrVals extras optional-dependencies;

  optional-dependencies = with python3Packages; {
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

  nativeCheckInputs = with python3Packages; [
    pytest-cov-stub
    pytest-textual-snapshot
    pytestCheckHook
  ];

  pythonRelaxDeps = [
    "art"
    "click"
    "pandas"
    "pymupdf"
    "pyperclip"
    "rich-click"
    "rich-pixels"
    "rich"
    "textual"
  ];

  pythonImportsCheck = [
    "browsr"
  ];

  disabledTests = [
    # Tests require internet access
    "test_github_screenshot"
    "test_github_screenshot_license"
    "test_textual_app_context_path_github"
    "test_mkdocs_screenshot"
  ];

  meta = {
    description = "File explorer in your terminal";
    mainProgram = "browsr";
    homepage = "https://juftin.com/browsr";
    changelog = "https://github.com/juftin/browsr/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
