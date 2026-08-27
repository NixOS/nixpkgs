{
  lib,
  fetchFromGitHub,
  fetchPypi,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "nhentai";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "RicterZ";
    repo = "doujinshi-dl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-h/7uJThrGA4MEksHVHqAoToYgaYrFOLJd30mXP83Sfg=";
  };

  build-system = with python3Packages; [ poetry-core ];

  dependencies = with python3Packages; [
    beautifulsoup4
    chardet
    httpx
    iso8601
    requests
    soupsieve
    tabulate
    urllib3
  ];

  # Project has no test
  doCheck = false;

  pythonImportsCheck = [ "doujinshi_dl" ];

  meta = {
    description = "CLI tool for downloading doujinshi from adult site(s)";
    homepage = "https://github.com/RicterZ/doujinshi-dl";
    changelog = "https://github.com/RicterZ/doujinshi-dl/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "nhentai";
  };
})
