{
  lib,
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonApplication {
  pname = "animdl";
  version = "1.7.27";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "justfoolingaround";
    repo = "animdl";
    # Using the commit hash because upstream does not have releases. https://github.com/justfoolingaround/animdl/issues/277
    rev = "c7c3b79198e66695e0bbbc576f9d9b788616957f";
    hash = "sha256-kn6vCCFhJNlruxoO+PTHVIwTf1E5j1aSdBhrFuGzUq4=";
  };

  pythonRemoveDeps = [
    "comtypes" # windows only
  ];

  pythonRelaxDeps = [
    "click"
    "cssselect"
    "httpx"
    "lxml"
    "packaging"
    "pycryptodomex"
    "regex"
    "rich"
    "tqdm"
    "yarl"
  ];

  build-system = with python3Packages; [
    poetry-core
  ];

  dependencies = with python3Packages; [
    anchor-kr
    anitopy
    click
    cssselect
    httpx
    lxml
    packaging
    pkginfo
    pycryptodomex
    pyyaml
    regex
    rich
    tqdm
    yarl
  ];

  doCheck = true;

  meta = {
    description = "Highly efficient, powerful and fast anime scraper";
    homepage = "https://github.com/justfoolingaround/animdl";
    license = lib.licenses.gpl3Only;
    mainProgram = "animdl";
    maintainers = with lib.maintainers; [ passivelemon ];
  };
}
