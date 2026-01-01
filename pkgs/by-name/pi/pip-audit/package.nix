{
  lib,
  fetchFromGitHub,
  python3,
<<<<<<< HEAD
  writableTmpDirAsHomeHook,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pip-audit";
<<<<<<< HEAD
  version = "2.10.0";
=======
  version = "2.9.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "trailofbits";
    repo = "pip-audit";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-fnIwtXFswKcfz/8VssL4UVukwkq6CC63NCyqqbqziO8=";
=======
    hash = "sha256-j8ZKqE7PEwaCTUNnJunqM0A2eyuWfx8zG5i3nmZERow=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
      tomli
      tomli-w
=======
      toml
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    ]
    ++ cachecontrol.optional-dependencies.filecache;

  nativeCheckInputs = with python3.pkgs; [
    pretend
    pytestCheckHook
<<<<<<< HEAD
    writableTmpDirAsHomeHook
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  pythonImportsCheck = [ "pip_audit" ];

<<<<<<< HEAD
=======
  preCheck = ''
    export HOME=$(mktemp -d);
  '';

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  disabledTestPaths = [
    # Tests require network access
    "test/dependency_source/test_requirement.py"
    "test/service/test_pypi.py"
    "test/service/test_osv.py"
  ];

  disabledTests = [
<<<<<<< HEAD
    # Tests require network access
    "test_esms"
    "test_get_pip_cache"
    "test_pyproject_source_duplicate_deps"
    "test_pyproject_source"
    "test_virtual_env"
  ];

  meta = {
    description = "Tool for scanning Python environments for known vulnerabilities";
    homepage = "https://github.com/trailofbits/pip-audit";
    changelog = "https://github.com/pypa/pip-audit/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
=======
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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "pip-audit";
  };
}
