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
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vdGtdJGkaUzH2JoxuFsfM57OodlxbEHuLl81giKUn6U=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    attrs
    click
    click-log
    jinja2
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
  };
}
