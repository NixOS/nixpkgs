{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "bbot";
  version = "3.0.2";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-kr1nKzBtUA2LJHh+43UP8DF6NHtmMish2uQyOvzxHEU=";
  };

  pythonRelaxDeps = [
    "dnspython"
    "idna"
    "lxml"
    "radixtarget"
    "regex"
    "tabulate"
    "websockets"
    "yara-python"
    "pyjwt"
    "cloudcheck"
  ];

  build-system = with python3.pkgs; [ hatchling ];

  dependencies = with python3.pkgs; [
    ansible-core
    ansible-runner
    asndb
    beautifulsoup4
    blastdns
    blasthttp
    cachetools
    cloudcheck
    deepdiff
    dnspython
    httpx
    idna
    jinja2
    lxml
    mmh3
    omegaconf
    orjson
    pip
    psutil
    puremagic
    pycryptodome
    pydantic
    pyjwt
    pyzmq
    radixtarget
    regex
    setproctitle
    socksio
    tabulate
    tldextract
    unidecode
    websockets
    wordninja
    xmltojson
    xxhash
    yara-python
    starlette
    tornado
    zstandard
  ];

  # Project has no tests
  doCheck = false;

  meta = {
    description = "OSINT automation for hackers";
    homepage = "https://github.com/blacklanternsecurity/bbot";
    changelog = "https://github.com/blacklanternsecurity/bbot/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      fab
      robsliwi
    ];
    mainProgram = "bbot";
  };
})
