{
  buildPythonPackage,
  fetchFromGitHub,
  nodejs,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_11,
  pyprojectVersionPatchHook,
  setuptools,
  meta,
}:
let
  pnpm = pnpm_11;
in
buildPythonPackage (finalAttrs: {
  pname = "esphome-device-builder-frontend";
  version = "0.1.371";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "esphome";
    repo = "device-builder-frontend";
    tag = finalAttrs.version;
    hash = "sha256-0aZzvlkv8x+MBMJsvJ2uztFJSaq29qgE16d0M3s7igU=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname src;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-YuPZWBtDBoJ/Ha/A70zXsJoXUXh+IxIxMo6w1DT5fwQ=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pyprojectVersionPatchHook
    pnpm
  ];

  build-system = [
    setuptools
  ];

  preBuild = ''
    pnpm run build
  '';

  pythonImportsCheck = [
    "esphome_device_builder_frontend"
  ];

  meta = meta // {
    description = "Frontend for the ESPHome Device Builder";
    homepage = "https://github.com/esphome/device-builder-frontend";
    changelog = "https://github.com/esphome/device-builder/releases/tag/${finalAttrs.src.tag}";
  };
})
