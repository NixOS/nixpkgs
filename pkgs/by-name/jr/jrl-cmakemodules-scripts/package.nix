{
  jrl-cmakemodules,
  gitMinimal,
  python3Packages,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  inherit (jrl-cmakemodules) version src;

  pname = "jrl-cmakemodules-scripts";
  pyproject = true;

  sourceRoot = "${finalAttrs.src.name}/v2/scripts";

  build-system = [ python3Packages.setuptools ];

  dependencies = [
    python3Packages.cmake-parser
    python3Packages.packaging
    python3Packages.rich
    python3Packages.ruamel-yaml
    python3Packages.tomlkit
  ];

  nativeCheckInputs = [
    gitMinimal
    python3Packages.pytest-mock
    python3Packages.pytestCheckHook
  ];

  __structuredAttrs = true;
  strictDeps = true;

  meta = jrl-cmakemodules.meta // {
    description = "Release scripting tools for JRL CMake modules";
    mainProgram = "jrl-release";
  };
})
