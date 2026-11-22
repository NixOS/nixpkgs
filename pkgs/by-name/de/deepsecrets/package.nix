{
  lib,
  stdenv,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "deepsecrets";
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ntoskernel";
    repo = "deepsecrets";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9iO6l+2LkR4o2/ssmb8IrApfaKdBg5pdIGhXqrVa1WU=";
  };

  pythonRelaxDeps = true;

  build-system = with python3.pkgs; [ poetry-core ];

  dependencies = with python3.pkgs; [
    aenum
    jschema-to-python
    mmh3
    ordered-set
    puppetparser
    pydantic
    pygments
    pyyaml
    regex
    rich
    sarif-om
  ];

  nativeCheckInputs = with python3.pkgs; [ pytestCheckHook ];

  disabledTests = [
    # assumes package is built in /app (docker?), and not /build/${finalAttrs.src.name} (nix sandbox)
    "test_1_cli"
    "test_config"
    "test_a_long_tmpdir_no_longer_breaks_the_manager_or_the_forkserver"
    "test_stop_forkserver_accounts_the_workers_and_never_hangs"
  ];

  pythonImportsCheck = [ "deepsecrets" ];

  meta = {
    description = "Secrets scanner that understands code";
    homepage = "https://github.com/ntoskernel/deepsecrets";
    changelog = "https://github.com/ntoskernel/deepsecrets/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "deepsecrets";
    broken = stdenv.hostPlatform.isDarwin;
  };
})
