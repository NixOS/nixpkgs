{
  lib,
  fetchFromGitHub,
  gitMinimal,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "git-privacy";
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "EMPRI-DEVOPS";
    repo = "git-privacy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-b2RkRL8/mZwqc3xCs+oltzualhQtp/7F9POlLlT3UUU=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  postPatch = ''
    # https://github.com/EMPRI-DEVOPS/git-privacy/issues/52
    substituteInPlace gitprivacy/gitprivacy.py \
      --replace "from pkg_resources import resource_stream, resource_string" "from importlib import resources" \
      --replace "hook_txt = resource_string('gitprivacy.resources.hooks', hook).decode()" "hook_txt = resources.files('gitprivacy.resources.hooks').joinpath(hook).read_text()" \
      --replace "with resource_stream('gitprivacy.resources.hooks', hook) as src, dst:" "with resources.files('gitprivacy.resources.hooks').joinpath(hook).open('rb') as src, dst:"
  '';

  dependencies = with python3.pkgs; [
    click
    git-filter-repo
    gitpython
    packaging
    pynacl
    setuptools
  ];

  nativeCheckInputs = with python3.pkgs; [
    gitMinimal
    packaging
    pytestCheckHook
    setuptools
  ];

  disabledTests = [
    # Tests want to interact with a git repo
    "TestGitPrivacy"
  ];

  pythonImportsCheck = [ "gitprivacy" ];

  meta = {
    description = "Tool to redact Git author and committer dates";
    homepage = "https://github.com/EMPRI-DEVOPS/git-privacy";
    changelog = "https://github.com/EMPRI-DEVOPS/git-privacy/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "git-privacy";
  };
})
