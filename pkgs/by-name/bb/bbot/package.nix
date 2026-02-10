{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "bbot";
  version = "2.7.2";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-vpKezG1nJVxQE4Qijf8feeRFD4hjy98HznVDXL+MBkE=";
  };

  pythonRelaxDeps = [
    "dnspython"
    "radixtarget"
    "regex"
    "tabulate"
  ];

  build-system = with python3.pkgs; [
    poetry-core
    poetry-dynamic-versioning
  ];

  dependencies = with python3.pkgs; [
    ansible-core
    ansible-runner
    beautifulsoup4
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

  ];

  # Project has no tests
  doCheck = false;

  meta = {
    description = "OSINT automation for hackers";
    homepage = "https://pypi.org/project/bbot/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "bbot";
  };
})
