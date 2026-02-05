{
  lib,
  python3,
  fetchPypi,
  pandoc,
  git,
  scriv,
  testers,
  fetchpatch,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "scriv";
  version = "1.7.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fBqL5jUdA2kuXnV4Te6g2PEbLJD5G+GLD7OjdVVbUl4=";
  };

  patches = [
    # fix tests by removing deprecated Click parameter from fixture
    (fetchpatch {
      url = "https://github.com/nedbat/scriv/commit/04ac45da9e1adb24a95ad9643099fe537b3790fd.diff";
      hash = "sha256-Gle3zWC/WypGHsKmVlqedRAZVWsBjGpzMq3uKuG9+SY=";
    })
  ];

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
    # test fails due to a pandoc bug (fixed in pandoc 3.6.4)
    "test_convert_to_markdown"
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
