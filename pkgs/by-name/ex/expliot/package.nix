{
  lib,
  fetchFromGitLab,
  python3,
}:
with python3.pkgs;
buildPythonApplication rec {
  pname = "expliot";
  version = "0.11.1";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "expliot_framework";
    repo = "expliot";
    tag = version;
    hash = "sha256-aFJVT5vE9YKirZEINKFzYWDffoVgluoUyvMmOifLq1M=";
  };

  build-system = [
    poetry-core
  ];

  pythonRelaxDeps = [
    "cryptography"
    "paho-mqtt"
    "pynetdicom"
    "setuptools"
    "xmltodict"
    "zeroconf"
  ];

  dependencies = [
    aiocoap
    awsiotpythonsdk
    bluepy
    cmd2
    cryptography
    distro
    jsonschema
    paho-mqtt
    pyi2cflash
    pymodbus
    pynetdicom
    pyparsing
    pyspiflash
    python-can
    python-magic
    pyudev
    setuptools
    upnpy
    xmltodict
    zeroconf
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "expliot" ];

  meta = {
    description = "IoT security testing and exploitation framework";
    longDescription = ''
      EXPLIoT is a Framework for security testing and exploiting IoT
      products and IoT infrastructure. It provides a set of plugins
      (test cases) which are used to perform the assessment and can
      be extended easily with new ones. The name EXPLIoT (pronounced
      expl-aa-yo-tee) is a pun on the word exploit and explains the
      purpose of the framework i.e. IoT exploitation.
    '';
    homepage = "https://expliot.readthedocs.io/";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "expliot";
  };
}
