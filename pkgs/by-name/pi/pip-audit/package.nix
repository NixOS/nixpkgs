{
  lib,
  fetchFromGitHub,
  python3,
  writableTmpDirAsHomeHook,
}:

let
  py = python3.override {
    packageOverrides = self: super: {

      # Requires cyclonedx-python-lib <10.0.0
      cyclonedx-python-lib = super.cyclonedx-python-lib.overridePythonAttrs (oldAttrs: rec {
        version = "9.1.0";
        src = fetchFromGitHub {
          owner = "CycloneDX";
          repo = "cyclonedx-python-lib";
          tag = "v${version}";
          hash = "sha256-XnRyE+C29W+rKrJop15jMNAXfAOdty877fKluhmEqIc=";
        };
      });
    };
  };
in

py.pkgs.buildPythonApplication rec {
  pname = "pip-audit";
  version = "2.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "trailofbits";
    repo = "pip-audit";
    tag = "v${version}";
    hash = "sha256-fnIwtXFswKcfz/8VssL4UVukwkq6CC63NCyqqbqziO8=";
  };

  build-system = with py.pkgs; [ flit-core ];

  dependencies =
    with py.pkgs;
    [
      cachecontrol
      cyclonedx-python-lib
      html5lib
      packaging
      pip-api
      pip-requirements-parser
      platformdirs
      rich
      tomli
      tomli-w
    ]
    ++ cachecontrol.optional-dependencies.filecache;

  nativeCheckInputs = with py.pkgs; [
    pretend
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "pip_audit" ];

  disabledTestPaths = [
    # Tests require network access
    "test/dependency_source/test_requirement.py"
    "test/service/test_pypi.py"
    "test/service/test_osv.py"
  ];

  disabledTests = [
    # Tests require network access
    "test_esms"
    "test_get_pip_cache"
    "test_pyproject_source_duplicate_deps"
    "test_pyproject_source"
    "test_virtual_env"
  ];

  meta = with lib; {
    description = "Tool for scanning Python environments for known vulnerabilities";
    homepage = "https://github.com/trailofbits/pip-audit";
    changelog = "https://github.com/pypa/pip-audit/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "pip-audit";
  };
}
