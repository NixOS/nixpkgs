{ lib, python3, fetchPypi, git, mercurial }:

python3.pkgs.buildPythonApplication rec {
  pname = "bumpver";
  version = "2021.1110";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tqDdt4234Arn/+iVv475f5HmMQ38HEchiWvf0ESxywM=";
  };

  prePatch = ''
    substituteInPlace setup.py \
      --replace "if any(arg.startswith(\"bdist\") for arg in sys.argv):" ""\
      --replace "import lib3to6" ""\
      --replace "package_dir = lib3to6.fix(package_dir)" ""
  '';

  propagatedBuildInputs = with python3.pkgs; [ pathlib2 click toml lexid colorama setuptools ];

  nativeCheckInputs = [ python3.pkgs.pytestCheckHook git mercurial ];

  disabledTests = [
    # fails due to more aggressive setuptools version specifier validation
    "test_parse_default_pattern"
  ];

  meta = with lib; {
    description = "Bump version numbers in project files";
    homepage = "https://pypi.org/project/bumpver/";
    license = licenses.mit;
    maintainers = with maintainers; [ kfollesdal ];
    mainProgram = "bumpver";
  };
}
