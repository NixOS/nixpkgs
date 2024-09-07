{ lib,
  buildPythonApplication,
  fetchFromGitHub,
  poetry-core,
  anchor-kr,
  anitopy,
  click,
  cssselect,
  httpx,
  lxml,
  packaging,
  pkginfo,
  pycryptodomex,
  pyyaml,
  regex,
  rich,
  tqdm,
  yarl
}:
buildPythonApplication {
  pname = "animdl";
  version = "1.7.27";
  format = "pyproject";

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
    "httpx"
    "lxml"
    "packaging"
    "pycryptodomex"
    "regex"
    "rich"
    "tqdm"
    "yarl"
  ];

  nativeBuildInputs = [
    poetry-core
  ];
  propagatedBuildInputs = [
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

  meta = with lib; {
    description = "Highly efficient, powerful and fast anime scraper";
    homepage = "https://github.com/justfoolingaround/animdl";
    license = licenses.gpl3Only;
    mainProgram = "animdl";
    maintainers = with maintainers; [ passivelemon ];
    platforms = [ "x86_64-linux" ];
  };
}
