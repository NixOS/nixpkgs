{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "gh-cherry-pick";
  version = "1.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PerchunPak";
    repo = "gh-cherry-pick";
    tag = "v${finalAttrs.version}";
    hash = "sha256-plNxOYLfKWLjN5RR1g2VOJWgyrzXdgI0MDJYe05XcCk=";
  };

  build-system = with python3Packages; [
    hatchling
    uv-dynamic-versioning
  ];

  dependencies = with python3Packages; [
    cyclopts
    httpx
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pytest-cov-stub
    pytest-mock
  ];

  pythonImportsCheck = [ "gh_cherry_pick" ];

  meta = {
    description = "Cherry-pick commits across GitHub repositories using only the GitHub API";
    homepage = "https://github.com/PerchunPak/gh-cherry-pick";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.PerchunPak ];
    mainProgram = "gh-cherry-pick";
  };
})
