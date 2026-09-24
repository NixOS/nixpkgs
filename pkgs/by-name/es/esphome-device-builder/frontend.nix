{
  buildPythonPackage,
  fetchFromGitHub,
  nodejs,
  fetchNpmDeps,
  npmHooks,
  pyprojectVersionPatchHook,
  setuptools,
  meta,
}:

buildPythonPackage (finalAttrs: {
  pname = "esphome-device-builder-frontend";
  version = "0.1.251";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "esphome";
    repo = "device-builder-frontend";
    tag = finalAttrs.version;
    hash = "sha256-lt7uDtoKcymm5wWygS44ff6TmSs1lPM1WdbygsEHcUc=";
  };

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = "sha256-JDpUk/aEgPpx8X2AuPlm7rCpvfOX0vfLHpSDlBRN/5o=";
  };

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
    pyprojectVersionPatchHook
  ];

  build-system = [
    setuptools
  ];

  preBuild = ''
    npm run build
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
