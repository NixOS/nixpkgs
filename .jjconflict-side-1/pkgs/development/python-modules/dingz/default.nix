{
  lib,
  aiohttp,
  async-timeout,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  pkg-resources-backport,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "dingz";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-ecosystem";
    repo = "python-dingz";
    tag = finalAttrs.version;
    hash = "sha256-bCytQwLWw8D1UkKb/3LQ301eDCkVR4alD6NHjTs6I+4=";
  };

  pythonRelaxDeps = [ "async_timeout" ];

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    async-timeout
    click
    pkg-resources-backport
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "dingz" ];

  meta = {
    description = "Python API for interacting with Dingz devices";
    homepage = "https://github.com/home-assistant-ecosystem/python-dingz";
    changelog = "https://github.com/home-assistant-ecosystem/python-dingz/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "dingz";
  };
})
