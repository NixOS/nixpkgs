{
  lib,
  aiohttp,
  aiooui,
  async-timeout,
  bleak,
  buildPythonPackage,
  dbus-fast,
  fetchFromGitHub,
  mac-vendor-lookup,
  myst-parser,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  sphinx-rtd-theme,
  sphinxHook,
  uart-devices,
  usb-devices,
}:

buildPythonPackage (finalAttrs: {
  pname = "bluetooth-adapters";
  version = "2.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = "bluetooth-adapters";
    tag = "v${finalAttrs.version}";
    hash = "sha256-d1vHb1WvsumlvilwuV6yfTwMXViLqeosSSM3LijIGYY=";
  };

  outputs = [
    "out"
    "doc"
  ];

  build-system = [
    poetry-core
  ];

  nativeBuildInputs = [
    myst-parser
    sphinx-rtd-theme
    sphinxHook
  ];

  dependencies = [
    aiohttp
    aiooui
    async-timeout
    bleak
    dbus-fast
    mac-vendor-lookup
    uart-devices
    usb-devices
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "bluetooth_adapters" ];

  meta = {
    description = "Tools to enumerate and find Bluetooth Adapters";
    homepage = "https://github.com/Bluetooth-Devices/bluetooth-adapters";
    changelog = "https://github.com/Bluetooth-Devices/bluetooth-adapters/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    teams = [ lib.teams.home-assistant ];
  };
})
