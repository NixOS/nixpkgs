{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pip-audit";
  version = "2.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "trailofbits";
    repo = "pip-audit";
    tag = "v${version}";
    hash = "sha256-j8ZKqE7PEwaCTUNnJunqM0A2eyuWfx8zG5i3nmZERow=";
  };

  pythonRelaxDeps = [ "cyclonedx-python-lib" ];

  build-system = with python3.pkgs; [ flit-core ];

  dependencies =
    with python3.pkgs;
    [
      cachecontrol
      cyclonedx-python-lib
      html5lib
      packaging
      pip-api
      pip-requirements-parser
      platformdirs
      rich
      toml
    ]
    ++ cachecontrol.optional-dependencies.filecache;

  nativeCheckInputs = with python3.pkgs; [
    pretend
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pip_audit" ];

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  disabledTestPaths = [
    # Tests require network access
    "test/dependency_source/test_requirement.py"
    "test/service/test_pypi.py"
    "test/service/test_osv.py"
  ];

  disabledTests = [
    # Tests requrire network access
    "test_get_pip_cache"
    "test_virtual_env"
    "test_pyproject_source"
    "test_pyproject_source_duplicate_deps"
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
