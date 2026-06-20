{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "embedxpl";
  version = "3.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mrhenrike";
    repo = "EmbedXPL-Forge";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UzlJFg/30xwUmWDoRBlTbHKgLvCudHOGeqyfBYQO2qQ=";
  };

  __structuredAttrs = true;

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    aiohttp
    colorama
    paramiko
    psutil
    pycryptodome
    pysnmp
    python-nmap
    requests
    rich
    scapy
    telnetlib3
  ];

  optional-dependencies = with python3.pkgs; {
    all = [
      numpy
      pymodbus
      python-can
      python-nmap
      scikit-learn
    ];
    at = [ python-can ];
    hvac = [ pymodbus ];
    iiot = [ pymodbus ];
    ml = [
      numpy
      scikit-learn
    ];
    ml-gpu = [
      numpy
      torch
    ];
    nse = [ python-nmap ];
    ot = [ pymodbus ];
    specialized = [ python-can ];
    vehicles = [ python-can ];
  };

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "embedxpl" ];

  meta = {
    description = "Embedded Device Security Assessment Framework";
    homepage = "https://github.com/mrhenrike/EmbedXPL-Forge";
    changelog = "https://github.com/mrhenrike/EmbedXPL-Forge/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "exf";
  };
})
