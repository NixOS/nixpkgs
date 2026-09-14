{
  buildPythonPackage,
  fetchFromGitHub,
  nodejs,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm,
  pyprojectVersionPatchHook,
  setuptools,
  meta,
}:

buildPythonPackage (finalAttrs: {
  pname = "esphome-device-builder-frontend";
  version = "0.1.311";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "esphome";
    repo = "device-builder-frontend";
    tag = finalAttrs.version;
    hash = "sha256-mCzWCoxm3yIgBhuEF9N3+5dk5PxKNcPhw0b2zQH9Hc0=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname src;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-91LytgWi+vHmsZjorw9QM1mcZAEvAOJXNz2rarAE4Vc=";
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
