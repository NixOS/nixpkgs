{ lib
, python3
, fetchPypi
, pandoc
, git
, scriv
, testers
}:

python3.pkgs.buildPythonApplication rec {
  pname = "scriv";
  version = "1.5.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+OTWFDnHCF2bxQU8f7DfULYG1cA9tOZCsNRPdKobns8=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    attrs
    click
    click-log
    jinja2
    markdown-it-py
    requests
  ] ++ lib.optionals (python3.pythonOlder "3.11") [
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
  ];

  passthru.tests = {
    version = testers.testVersion { package = scriv; };
  };

  meta = {
    description = "Command-line tool for helping developers maintain useful changelogs.";
    homepage = "https://github.com/nedbat/scriv";
    changelog = "https://github.com/nedbat/scriv/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ amesgen ];
    mainProgram = "scriv";
  };
}
