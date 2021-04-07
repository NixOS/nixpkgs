{ lib, python3, git, mercurial}:

python3.pkgs.buildPythonApplication rec {
  pname = "bumpver";
  version = "2021.1110";

  src = python3.pkgs.fetchPypi {
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

  checkInputs = [ python3.pkgs.pytestCheckHook git mercurial];

  meta = with lib; {
    description = "Bump version numbers in project files";
    homepage = "https://pypi.org/project/bumpver/";
    license = licenses.mit;
    maintainers = with maintainers; [ kfollesdal ];
  };
}
