{ lib
, GitPython
, buildPythonApplication
, emoji
, fetchFromGitHub
, filetype
, ipython
, junit-xml
, lxml
, mock
, netaddr
, pytestCheckHook
, python3Packages
, radish-bdd
, semver
}:

buildPythonApplication rec {
  pname = "terraform-compliance";
  version = "1.2.11";

  # No tests in Pypi package
  src = fetchFromGitHub {
    owner = "eerkunt";
    repo = pname;
    rev = version;
    sha256 = "161mszmxqp3wypnda48ama2mmq8yjilkxahwc1mxjwzy1n19sn7v";
  };

  checkInputs = [ pytestCheckHook ];

  disabledTests = [
    "test_which_success"
    "test_readable_plan_file_is_not_json"
  ];

  propagatedBuildInputs = [
    GitPython
    emoji
    filetype
    ipython
    junit-xml
    lxml
    mock
    netaddr
    radish-bdd
    semver
  ];

  meta = with lib; {
    description = "BDD test framework for terraform";
    homepage = https://github.com/eerkunt/terraform-compliance;
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
  };
}
