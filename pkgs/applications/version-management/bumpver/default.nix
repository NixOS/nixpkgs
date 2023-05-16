<<<<<<< HEAD
{ lib, python3, fetchPypi, git, mercurial }:
=======
{ lib, python3, git, mercurial}:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

python3.pkgs.buildPythonApplication rec {
  pname = "bumpver";
  version = "2021.1110";

<<<<<<< HEAD
  src = fetchPypi {
=======
  src = python3.pkgs.fetchPypi {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    inherit pname version;
    sha256 = "b6a0ddb78db7e00ae7ffe895bf8ef97f91e6310dfc1c4721896bdfd044b1cb03";
  };

  prePatch = ''
    substituteInPlace setup.py \
      --replace "if any(arg.startswith(\"bdist\") for arg in sys.argv):" ""\
      --replace "import lib3to6" ""\
      --replace "package_dir = lib3to6.fix(package_dir)" ""
  '';

  propagatedBuildInputs = with python3.pkgs; [ pathlib2 click toml lexid colorama setuptools ];

<<<<<<< HEAD
  nativeCheckInputs = [ python3.pkgs.pytestCheckHook git mercurial ];
=======
  nativeCheckInputs = [ python3.pkgs.pytestCheckHook git mercurial];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabledTests = [
    # fails due to more aggressive setuptools version specifier validation
    "test_parse_default_pattern"
  ];

  meta = with lib; {
    description = "Bump version numbers in project files";
    homepage = "https://pypi.org/project/bumpver/";
    license = licenses.mit;
    maintainers = with maintainers; [ kfollesdal ];
  };
}
