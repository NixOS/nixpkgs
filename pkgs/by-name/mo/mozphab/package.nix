{
  lib,
  fetchFromGitHub,
  python3,

  # tests
  git,
  mercurial,
  patch,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "mozphab";
  version = "1.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mozilla-conduit";
    repo = "review";
    tag = version;
    hash = "sha256-CVpsq9YoEww47uruHYEsJk9YQ39ZFQsMdL0nBc8AHUM=";
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
    # AttributeError: 'called_once' is not a valid assertion.
    "test_commit"
    # AttributeError: 'not_called' is not a valid assertion.
    "test_finalize_no_evolve"
    "test_patch"
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

  meta = with lib; {
    description = "Phabricator CLI from Mozilla to support submission of a series of commits";
    mainProgram = "moz-phab";
    longDescription = ''
      moz-phab is a custom command-line tool, which communicates to
      Phabricator’s API, providing several conveniences, including support for
      submitting series of commits.
    '';
    homepage = "https://moz-conduit.readthedocs.io/en/latest/phabricator-user.html";
    license = licenses.mpl20;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
