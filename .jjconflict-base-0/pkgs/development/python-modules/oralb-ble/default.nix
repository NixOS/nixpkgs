{
  lib,
  bleak,
  bleak-retry-connector,
  bluetooth-data-tools,
  bluetooth-sensor-state-data,
  buildPythonPackage,
  fetchFromGitHub,
  home-assistant-bluetooth,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "oralb-ble";
  version = "0.18.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = "oralb-ble";
    rev = "refs/tags/v${version}";
    hash = "sha256-e6L8HXpqOAHnEktIJ1N1atC5QXno669W3c/S7cISa48=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail " --cov=oralb_ble --cov-report=term-missing:skip-covered" ""
  '';

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    bleak
    bleak-retry-connector
    bluetooth-data-tools
    bluetooth-sensor-state-data
    home-assistant-bluetooth
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "oralb_ble" ];

  disabledTests = [
    # Test is outdated, TypeError: BLEDevice.__init__() missing 2 required...
    "test_async_poll"
  ];

  meta = with lib; {
    description = "Library for Oral B BLE devices";
    homepage = "https://github.com/Bluetooth-Devices/oralb-ble";
    changelog = "https://github.com/Bluetooth-Devices/oralb-ble/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
