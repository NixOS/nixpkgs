{
  lib,
  python3,
  fetchPypi,
  pandoc,
  git,
  scriv,
  testers,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "scriv";
  version = "1.7.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fBqL5jUdA2kuXnV4Te6g2PEbLJD5G+GLD7OjdVVbUl4=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies =
    with python3.pkgs;
    [
      attrs
      click
      click-log
      jinja2
      markdown-it-py
      requests
    ]
    ++ lib.optionals (python3.pythonOlder "3.11") [
      tomli
    ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
    coverage
    freezegun
    pudb
    pytest-mock
    responses
    pyyaml

    pandoc
    git
  ];
  disabledTests = [
    # assumes we have checked out the full repo (including remotes)
    "test_real_get_github_repos"
    # requires a newer pandoc version (as it tests for a specific format of the
    # error message)
    "test_bad_convert_to_markdown"
  ];

  passthru.tests = {
    version = testers.testVersion { package = scriv; };
  };

  meta = {
    description = "Command-line tool for helping developers maintain useful changelogs";
    homepage = "https://github.com/nedbat/scriv";
    changelog = "https://github.com/nedbat/scriv/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ amesgen ];
    mainProgram = "scriv";
  };
}
