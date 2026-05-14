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

buildPythonPackage (finalAttrs: {
  pname = "esphome-dashboard";
  version = "20260408.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "esphome";
    repo = "dashboard";
    tag = finalAttrs.version;
    hash = "sha256-OY7s/b0rWmjI9QfmEwj3VxbTFrj99fyf9x1tPl24RbI=";
  };

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
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
})
