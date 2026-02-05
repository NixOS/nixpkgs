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
  version = "20260110.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "esphome";
    repo = "dashboard";
    tag = version;
    hash = "sha256-h8g/MRfOBkiCKNTOM4I6OimsE5ljgsIMQLl1eZLfP3U=";
  };

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-DkK2WG7oWHvwYflNdwOMfE0OVP2ICEGAhhTH2rix9zc=";
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
