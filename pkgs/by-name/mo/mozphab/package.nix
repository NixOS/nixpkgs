{
  lib,
  fetchFromGitHub,
  python3,
  nix-update-script,

  # tests
  git,
  jujutsu,
  mercurial,
  patch,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "mozphab";
  version = "2.15.3";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mozilla-conduit";
    repo = "review";
    tag = finalAttrs.version;
    hash = "sha256-QqWvwKkD0WL50E9NmgXmgxM8zATXdJTdK4l/CYk0lgk=";
  };

  build-system = with python3.pkgs; [
    setuptools
    setuptools-scm
  ];

  pythonRelaxDeps = [ "glean-sdk" ];

  dependencies = with python3.pkgs; [
    colorama
    distro
    glean-sdk
    packaging
    python-hglib
    sentry-sdk
    setuptools
  ];

  nativeCheckInputs = [
    git
    jujutsu
    mercurial
    patch
  ]
  ++ (with python3.pkgs; [
    callee
    immutabledict
    hg-evolve
    mock
    pytestCheckHook
  ]);

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests = [
    # Seems to expect an older `jj` version:
    # AssertionError: A broken `jj` config should surface a `jj git root` error.
    "test_jj_broken_config_surfaces_error"
  ];

  disabledTestPaths = [
    # codestyle doesn't matter to us
    "tests/test_style.py"
    # integration tests try to submit changes, which requires network access
    "tests/test_integration_git.py"
    "tests/test_integration_hg.py"
    "tests/test_integration_hg_dag.py"
    "tests/test_integration_patch.py"
    "tests/test_integration_reorganise.py"
    "tests/test_sentry.py"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Phabricator CLI from Mozilla to support submission of a series of commits";
    mainProgram = "moz-phab";
    longDescription = ''
      moz-phab is a custom command-line tool, which communicates to
      Phabricator’s API, providing several conveniences, including support for
      submitting series of commits.
    '';
    homepage = "https://moz-conduit.readthedocs.io/en/latest/phabricator-user.html";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ choco98 ];
    platforms = lib.platforms.unix;
  };
})
