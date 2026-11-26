{
  lib,
  buildPythonPackage,
  fetchPnpmDeps,
  fetchFromGitHub,
  music-assistant,
  nodejs,
  pnpm_11,
  pnpmConfigHook,
  pyprojectVersionPatchHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "music-assistant-frontend";
  version = "2.17.381";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "music-assistant";
    repo = "frontend";
    tag = finalAttrs.version;
    hash = "sha256-KCONItsUp9DdqbB/MB3bT6u9kvkJ5eegiwuWrSJKq3I=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_11
    pnpmConfigHook
    pyprojectVersionPatchHook
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_11;
    fetcherVersion = 5;
    hash = "sha256-0n2dI91jP0Eq+ewWEVukSeNRNzsAU/Nao2OwV35KuSc=";
  };

  build-system = [ setuptools ];

  preBuild = ''
    pnpm build
  '';

  doCheck = false;

  pythonImportsCheck = [ "music_assistant_frontend" ];

  meta = {
    changelog = "https://github.com/music-assistant/frontend/releases/tag/${finalAttrs.version}";
    description = "Music Assistant frontend";
    homepage = "https://github.com/music-assistant/frontend";
    license = lib.licenses.asl20;
    inherit (music-assistant.meta) maintainers;
  };
})
