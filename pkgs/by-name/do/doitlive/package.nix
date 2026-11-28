{
  lib,
  bash,
  fetchFromGitHub,
  git,
  python3Packages,
  which,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "doitlive";
  version = "5.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sloria";
    repo = "doitlive";
    tag = finalAttrs.version;
    hash = "sha256-3dihv/Nfs91Et2el0MxIy9mfrDWC6Dck+//g0uLVPlc=";
  };

  postPatch = ''
    # The recorder test runs this shell.
    substituteInPlace tests/test_doitlive.py \
      --replace-fail /bin/bash ${lib.getExe bash}
  '';

  build-system = with python3Packages; [ flit-core ];

  dependencies = with python3Packages; [
    click
    click-completion
    click-didyoumean
  ];

  nativeCheckInputs = [
    git
    which
    writableTmpDirAsHomeHook
  ]
  ++ (with python3Packages; [
    ipython
    pytestCheckHook
  ]);

  # Playback opens /dev/tty, which the sandbox does not provide.
  # Upstream skips that path when CI is set.
  env.CI = "1";

  pythonImportsCheck = [ "doitlive" ];

  meta = {
    description = "Tool for live presentations in the terminal";
    homepage = "https://github.com/sloria/doitlive";
    changelog = "https://github.com/sloria/doitlive/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ iamanaws ];
    mainProgram = "doitlive";
  };
})
