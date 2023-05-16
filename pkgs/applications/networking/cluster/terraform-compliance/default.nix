{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "terraform-compliance";
<<<<<<< HEAD
  version = "1.3.44";
=======
  version = "1.3.34";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "terraform-compliance";
    repo = "cli";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    sha256 = "sha256-eE9bqu9ipuas+rdcJpn09V6nkdoYPOpChHgPH8U0rNw=";
=======
    sha256 = "sha256-1TFLpBwkpMMdiJJfVvDXlJg4SXWQ8VV605wMFGU+InQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "IPython==7.16.1" "IPython" \
<<<<<<< HEAD
      --replace "diskcache==5.1.0" "diskcache>=5.1.0" \
      --replace "radish-bdd==0.13.1" "radish-bdd" \
=======
      --replace "diskcache==5.1.0" "diskcache>=5.1.0"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    orjson
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    maintainers = with maintainers; [ kalbasit kashw2 ];
=======
    maintainers = with maintainers; [ kalbasit ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
