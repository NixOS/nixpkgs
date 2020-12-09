{ lib, python3, git, mercurial}:

python3.pkgs.buildPythonApplication rec {
  pname = "bumpver";
  version = "2020.1107";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "75704333a8d1699e2cadcf1fcd3027a2cab6837ae343af10a61c6eef4e0313d7";
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
