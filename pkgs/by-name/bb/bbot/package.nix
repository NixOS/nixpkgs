{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "bbot";
  version = "2.8.6";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-u8F995BD1l6nPWYckMIYSgErSO3fBcU2IyBFU1WZjF8=";
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
    maintainers = with lib.maintainers; [
      fab
      robsliwi
    ];
    mainProgram = "bbot";
  };
})
