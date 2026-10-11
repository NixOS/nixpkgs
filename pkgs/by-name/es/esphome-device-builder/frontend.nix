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
  version = "0.1.368";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "esphome";
    repo = "device-builder-frontend";
    tag = finalAttrs.version;
    hash = "sha256-bBGgPv0RekfFoBKCe1ZEVxgjAU3F0sJVVANPuXxBFt0=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname src;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-7/ds8mYzmGXzx7tFGI+qUJyhJvMnUARQh/VYhQYImb0=";
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
