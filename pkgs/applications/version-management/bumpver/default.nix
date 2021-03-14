{ lib, python3, git, mercurial}:

python3.pkgs.buildPythonApplication rec {
  pname = "bumpver";
  version = "2020.1108";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "1bhbrq8fk8rsr78vq9xjz8v9lgv571va0nmg86dwmv6qnj6dymzm";
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
