{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonPackage rec {
  pname = "accuweather";
  version = "4.2.2";
  pyproject = true;

  disabled = python3Packages.pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "bieniu";
    repo = "accuweather";
    tag = version;
    hash = "sha256-ORxo92nfLGNRC+eWX4NrpoMgiCLbtfR5JA+23OT/L3Y=";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = [
    python3Packages.aiohttp
    python3Packages.orjson
  ];

  nativeCheckInputs = [
    python3Packages.aioresponses
    python3Packages.pytest-asyncio
    python3Packages.pytest-error-for-skips
    python3Packages.pytestCheckHook
    python3Packages.syrupy
  ];

  pythonImportsCheck = [ "accuweather" ];

  meta = {
    description = "Python wrapper for getting weather data from AccuWeather servers";
    homepage = "https://github.com/bieniu/accuweather";
    changelog = "https://github.com/bieniu/accuweather/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jamiemagee ];
  };
}
