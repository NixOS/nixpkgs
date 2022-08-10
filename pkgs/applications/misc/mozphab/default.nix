{ lib
, fetchFromGitHub
, python3

# tests
, git
, mercurial
, patch
}:

python3.pkgs.buildPythonApplication rec {
  pname = "mozphab";
  version = "1.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mozilla-conduit";
    repo = "review";
    rev = "refs/tags/${version}";
    hash = "sha256-vLHikGjTYOeXd6jDRsoCkq3i0eh6Ttd4KdvlixjzdZ4=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "glean-sdk>=50.0.1,==50.*" "glean-sdk"
  '';

  propagatedBuildInputs = with python3.pkgs; [
    distro
    glean-sdk
    packaging
    python-hglib
    sentry-sdk
    setuptools
  ];

  checkInputs = [
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
    longDescription = ''
      moz-phab is a custom command-line tool, which communicates to
      Phabricator’s API, providing several conveniences, including support for
      submitting series of commits.
    '';
    homepage = "https://moz-conduit.readthedocs.io/en/latest/phabricator-user.html";
    license = licenses.mpl20;
    maintainers = with maintainers; [];
    platforms = platforms.unix;
  };
}
