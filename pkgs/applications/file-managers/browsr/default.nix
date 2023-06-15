{ lib
, python3
, fetchFromGitHub
, extras ? [ "all" ]
}:

python3.pkgs.buildPythonApplication rec {
  pname = "browsr";
  version = "1.10.7";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "juftin";
    repo = "browsr";
    rev = "v${version}";
    hash = "sha256-AT5cFQ4CldlHv3MQYAGXdZVB3bNAAvbJeosdxZjcPBM=";
  };

  nativeBuildInputs = with python3.pkgs; [
    hatchling
    pythonRelaxDepsHook
    pytestCheckHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
    art
    click
    fsspec
    pandas
    pillow
    pymupdf
    rich
    rich-click
    rich-pixels
    textual
    universal-pathlib
  ] ++ lib.attrVals extras passthru.optional-dependencies;

  passthru.optional-dependencies = with python3.pkgs; {
    all = [
      adlfs
      aiohttp
      gcsfs
      paramiko
      pyarrow
      requests
      s3fs
    ];
    parquet = [
      pyarrow
    ];
    remote = [
      adlfs
      aiohttp
      gcsfs
      paramiko
      requests
      s3fs
    ];
  };

  pythonRelaxDeps = [
    "art"
    "fsspec"
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
    homepage = "https://github.com/juftin/browsr";
    changelog = "https://github.com/fsspec/universal_pathlib/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
