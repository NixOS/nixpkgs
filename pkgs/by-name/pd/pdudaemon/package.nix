{
  lib,
  fetchFromGitHub,
  python3Packages,
  nixosTests,
}:

python3Packages.buildPythonApplication rec {
  pname = "pdudaemon";
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pdudaemon";
    repo = "pdudaemon";
    tag = version;
    hash = "sha256-YjM1RmsdRfNyxCzK+PmSH8n7ZJ3qeIskTPxu2+EaupQ=";
  };

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  dependencies = with python3Packages; [
    aiohttp
    requests
    pexpect
    systemd-python
    paramiko
    pyserial
    hidapi
    pysnmp
    pyasn1
    pyusb
    pymodbus
  ];

  nativeCheckInputs = with python3Packages; [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  __structuredAttrs = true;

  passthru.tests = {
    inherit (nixosTests) pdudaemon;
  };

  meta = {
    changelog = "https://github.com/pdudaemon/pdudaemon/releases/tag/${src.tag}";
    description = "Python Daemon for controlling/sequentially executing commands to PDUs (Power Distribution Units)";
    homepage = "https://github.com/pdudaemon/pdudaemon";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      aiyion
      emantor
    ];
    mainProgram = "pdudaemon";
  };
}
