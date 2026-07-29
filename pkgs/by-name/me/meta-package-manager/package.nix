{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "meta-package-manager";
  version = "8.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kdeldycke";
    repo = "meta-package-manager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tIRTAE6CbuXKpH19FkvFnpm4b+UG2RBn+H861kbq5zo=";
  };

  build-system = with python3Packages; [ uv-build ];

  dependencies = with python3Packages; [
    click-extra
    extra-platforms
    tomli-w
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    # Registers the `xdist_group` marker the suite applies, which the strict
    # marker check of 8.3.0 refuses to collect unregistered. Its setup hook
    # also spreads the suite over every build core.
    pytest-xdist
    # tests/test_docs.py parses the GitHub workflow YAML files and loads
    # docs/docs_update.py, which round-trips pyproject.toml with tomlrt.
    pyyaml
    tomlrt
    # The SBOM unit tests import the `[sbom-offline]` and `[sbom-online]`
    # extras: the CycloneDX renderer and its JSON/XML schema validators, the
    # purl and SPDX writers, and the mocked HTTP client of the OSV adapter.
    cyclonedx-python-lib
    httpx
    jsonschema
    lxml
    packageurl-python
    respx
    spdx-tools
  ];

  pythonImportsCheck = [ "meta_package_manager" ];

  meta = {
    description = "Package managers abstraction and unification tool";
    homepage = "https://mpm.run/";
    changelog = "https://github.com/kdeldycke/meta-package-manager/blob/v${finalAttrs.version}/changelog.md";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ kdeldycke ];
    mainProgram = "mpm";
  };
})
