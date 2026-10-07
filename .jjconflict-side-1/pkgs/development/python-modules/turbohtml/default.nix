{
  buildPythonPackage,
  docutils,
  fetchFromGitHub,
  httpx2,
  jinja2,
  lib,
  meson,
  meson-python,
  ninja,
  pyperf,
  pyprojectVersionPatchHook,
  pytest-codspeed,
  pytest-mock,
  pytestCheckHook,
  tenacity,
}:

let
  html5lib-tests = fetchFromGitHub {
    owner = "html5lib";
    repo = "html5lib-tests";
    rev = "9fb614afaa42ce8787840f057b32084308e76549";
    hash = "sha256-I9Sp8wCO0oXRzdmIsR889fSlzM8GXUoDc7tFUuDBmKk=";
  };
in
buildPythonPackage (finalAttrs: {
  pname = "turbohtml";
  version = "1.13.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tox-dev";
    repo = "turbohtml";
    tag = finalAttrs.version;
    hash = "sha256-ztkdLZll4kbDFLw+ZDSjcsRw93ltPhHQFXHrWoq2ITM=";
  };

  postPatch = ''
    rmdir tests/html5lib-tests
    ln -s ${html5lib-tests} tests/html5lib-tests

    patchShebangs tools
  '';

  nativeBuildInputs = [
    pyprojectVersionPatchHook
  ];

  build-system = [
    meson
    meson-python
    ninja
  ];

  pythonImportsCheck = [ "turbohtml" ];

  nativeCheckInputs = [
    docutils
    httpx2
    jinja2
    pyperf
    pytest-codspeed
    pytest-mock
    pytestCheckHook
    tenacity
  ];

  disabledTestPaths = [
    # we cannot generate the version from git
    "tests/build/test_generate_version.py"
    # tests depend on submodules
    "tests/conformance"
    "tests/url/test_idna.py"
  ];

  meta = {
    changelog = "https://github.com/tox-dev/turbohtml/blob/${finalAttrs.src.tag}/docs/changelog.rst";
    description = "Fast, fully typed HTML toolkit for Python, powered by a C-accelerated core";
    homepage = "https://github.com/tox-dev/turbohtml";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
