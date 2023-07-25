{ lib
, fetchFromGitHub
, git
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "git-privacy";
  version = "2.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "EMPRI-DEVOPS";
    repo = pname;
    rev = "v${version}";
    sha256 = "0hfy43fip1l81672xfwqrz1jryzkjy7h9f2lyikxgibibil0p444";
  };

  propagatedBuildInputs = with python3.pkgs; [
    click
    git-filter-repo
    gitpython
    pynacl
    setuptools
  ];

  nativeCheckInputs = with python3.pkgs; [
    git
    pytestCheckHook
  ];

  disabledTests = [
    # Tests want to interact with a git repo
    "TestGitPrivacy"
  ];

  pythonImportsCheck = [
    "gitprivacy"
  ];

  meta = with lib; {
    description = "Tool to redact Git author and committer dates";
    homepage = "https://github.com/EMPRI-DEVOPS/git-privacy";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ fab ];
  };
}
