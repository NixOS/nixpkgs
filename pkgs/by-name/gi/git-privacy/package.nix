{
  lib,
  fetchFromGitHub,
  fetchpatch,
  git,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "git-privacy";
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "EMPRI-DEVOPS";
    repo = "git-privacy";
    rev = "v${finalAttrs.version}";
    hash = "sha256-b2RkRL8/mZwqc3xCs+oltzualhQtp/7F9POlLlT3UUU=";
  };

  patches = [
    # Fix: pkg_resources is deprecated
    (fetchpatch {
      name = "fix-pkg_resources-is-deprecated.patch";
      url = "https://github.com/EMPRI-DEVOPS/git-privacy/commit/a54d7a8b9ce6a48db5383e09711059b5025bcb18.patch";
      excludes = [ ".github/workflows/pytest.yml" ];
      hash = "sha256-uorH+EomVS6wMoykwazSIstz43CCjU8tJLgxyINqxU4=";
    })
  ];

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    click
    git-filter-repo
    gitpython
    pynacl
    setuptools
  ];

  nativeCheckInputs = with python3.pkgs; [
    git
    pytestCheckHook
  ];

  disabledTests = [
    # Tests want to interact with a git repo
    "TestGitPrivacy"
  ];

  pythonImportsCheck = [
    "gitprivacy"
  ];

  meta = {
    description = "Tool to redact Git author and committer dates";
    homepage = "https://github.com/EMPRI-DEVOPS/git-privacy";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "git-privacy";
  };
})
