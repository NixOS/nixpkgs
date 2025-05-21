{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchNpmDeps,

  # build-system
  setuptools,
  nodejs,
  npmHooks,

}:

buildPythonPackage rec {
  pname = "esphome-dashboard";
  version = "20250415.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "esphome";
    repo = "dashboard";
    rev = "refs/tags/${version}";
    hash = "sha256-HpmHII1pSsSO/hEHcy/QHv7jxslpz9a6EeHcEZQ+VIA=";
  };

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-SiH6CqFOpDQMMtRcgxr0LSJKuziZoYVjgVTpKBoebbg=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
  ];

  postPatch = ''
    # https://github.com/esphome/dashboard/pull/639
    patchShebangs script/build
  '';

  preBuild = ''
    script/build
  '';

  # no tests
  doCheck = false;

  pythonImportsCheck = [
    "esphome_dashboard"
  ];

  meta = with lib; {
    description = "ESPHome dashboard";
    homepage = "https://esphome.io/";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ hexa ];
  };
}
