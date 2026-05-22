{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "gh-cherry-pick";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PerchunPak";
    repo = "gh-cherry-pick";
    tag = "v${finalAttrs.version}";
    hash = "sha256-a2vhQ9upJYc+t4Juq+eukNc7dzq6MafNxDUULPZs9sQ=";
  };

  build-system = with python3Packages; [
    hatchling
    uv-dynamic-versioning
  ];

  dependencies = with python3Packages; [
    cyclopts
    httpx
  ];

  # upstream has strict dependency pins, but it doesn't break with slightly
  # newer/older versions
  #   (c) upstream maintainer
  pythonRelaxDeps = true;

  nativeCheckInputs = with python3Packages; [
    faker
    pytest-asyncio
    pytest-cov-stub
    pytest-httpx
    pytest-mock
    pytestCheckHook
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
