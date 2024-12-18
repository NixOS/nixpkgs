{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "subprober";
  version = "1.0.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "RevoltSecurities";
    repo = "SubProber";
    rev = "refs/tags/v${version}";
    hash = "sha256-CxmePd1dw9H/XLQZ16JMF1pdFFOI59Qa2knTnKKzFvM=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    aiodns
    aiofiles
    aiohttp
    alive-progress
    anyio
    appdirs
    arsenic
    beautifulsoup4
    colorama
    fake-useragent
    httpx
    requests
    rich
    structlog
    urllib3
    uvloop
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "subprober" ];

  meta = with lib; {
    description = "Subdomain scanning tool";
    homepage = "https://github.com/RevoltSecurities/SubProber";
    changelog = "https://github.com/RevoltSecurities/SubProber/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "subprober";
  };
}
