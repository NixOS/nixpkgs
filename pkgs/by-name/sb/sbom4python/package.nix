{
  lib,
  python3Packages,
  fetchFromGitHub,
  sbom2dot,
  sbom4files,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "sbom4python";
  version = "0.12.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "anthonyharrison";
    repo = "sbom4python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0+7NsnM2ovYKX5ngFKrQ5lGj9gTrK87B81XSVEnmBWA=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    importlib-metadata
    lib4package
    lib4sbom
    sbom2dot
    sbom4files
    setuptools # for pkg_resources
    toml
  ];

  nativeCheckInputs = [
    versionCheckHook
  ];

  pythonImportsCheck = [
    "sbom4python"
  ];

  meta = {
    changelog = "https://github.com/anthonyharrison/sbom4python/releases/tag/${finalAttrs.src.tag}";
    description = "Tool to generate a SBOM (Software Bill of Materials) for an installed Python module";
    homepage = "https://github.com/anthonyharrison/sbom4python";
    license = lib.licenses.asl20;
    mainProgram = "sbom4python";
    maintainers = [ ];
  };
})
