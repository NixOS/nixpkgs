{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "gh-cherry-pick";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PerchunPak";
    repo = "gh-cherry-pick";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EiXWgiCV99k3810nCWA+AnlLjG8VKRCPnns9KtfGxqY=";
  };

  build-system = with python3Packages; [
    hatchling
    uv-dynamic-versioning
  ];

  pythonRelaxDeps = [
    "attrs"
    "trio"
  ];

  dependencies = with python3Packages; [
    attrs
    cyclopts
    httpx
    loguru
    trio
    typing-extensions
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pytest
    pytest-cov-stub
    pytest-mock
    pytest-trio
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
