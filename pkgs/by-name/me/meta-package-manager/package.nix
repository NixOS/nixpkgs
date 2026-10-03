{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
  zsh,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "meta-package-manager";
  version = "7.6.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kdeldycke";
    repo = "meta-package-manager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-P/lP9YCekXEzPKYJTsASuxnSbDuFKBw99nVK4p7v+M4=";
  };

  build-system = with python3Packages; [ uv-build ];

  dependencies = with python3Packages; [
    boltons
    click-extra
    extra-platforms
    packageurl-python
    tomli-w
    xmltodict
  ];

  nativeCheckInputs =
    with python3Packages;
    [
      pytestCheckHook
      # tests/test_docs.py parses the GitHub workflow YAML files and loads
      # docs/docs_update.py, which round-trips pyproject.toml with tomlkit.
      pyyaml
      tomlkit
      # The SBOM unit tests import the CycloneDX renderer and its JSON/XML
      # schema validators, the SPDX writers, and the mocked HTTP client of
      # the OSV adapter.
      cyclonedx-python-lib
      httpx
      jsonschema
      lxml
      platformdirs
      respx
      spdx-tools
    ]
    # The Xbar/SwiftBar plugin tests only run on macOS and drive the plugin
    # through the login shells it targets.
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ zsh ];

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
