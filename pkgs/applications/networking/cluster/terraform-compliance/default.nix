{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "terraform-compliance";
  version = "1.3.47";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "terraform-compliance";
    repo = "cli";
    rev = "refs/tags/${version}";
    sha256 = "sha256-QJDKBM5CTOdF7oT42vL+Yp1UsQXWvkSZzo+WSsDxAZw=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "IPython==7.16.1" "IPython" \
      --replace "diskcache==5.1.0" "diskcache>=5.1.0" \
      --replace "radish-bdd==0.13.1" "radish-bdd" \
  '';

  propagatedBuildInputs = with python3.pkgs; [
    diskcache
    emoji
    filetype
    gitpython
    ipython
    junit-xml
    lxml
    mock
    netaddr
    radish-bdd
    semver
    orjson
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  disabledTests = [
    "test_which_success"
    "test_readable_plan_file_is_not_json"
  ];

  pythonImportsCheck = [
    "terraform_compliance"
  ];

  meta = with lib; {
    description = "BDD test framework for terraform";
    homepage = "https://github.com/terraform-compliance/cli";
    changelog = "https://github.com/terraform-compliance/cli/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit kashw2 ];
  };
}
