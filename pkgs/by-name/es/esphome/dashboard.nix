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
  version = "20260210.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "esphome";
    repo = "dashboard";
    tag = version;
    hash = "sha256-Edd2ZOSBAZSrGVjbncyPhhjFjE0CxBHz16ZHXyzx9LI=";
  };

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-L6tKhijTFAvQwhBBl5Wk6xzI2dtDI6IYfCkiKX75Pvc=";
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

  meta = {
    description = "ESPHome dashboard";
    homepage = "https://esphome.io/";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ hexa ];
  };
}
