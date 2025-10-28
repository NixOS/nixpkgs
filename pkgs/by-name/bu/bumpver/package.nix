{
  lib,
  python3,
  fetchPypi,
  git,
  mercurial,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "bumpver";
  version = "2021.1110";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b6a0ddb78db7e00ae7ffe895bf8ef97f91e6310dfc1c4721896bdfd044b1cb03";
  };

  prePatch = ''
    substituteInPlace setup.py \
      --replace-fail "if any(arg.startswith(\"bdist\") for arg in sys.argv):" ""\
      --replace-fail "import lib3to6" ""\
      --replace-fail "package_dir = lib3to6.fix(package_dir)" ""
  '';

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    pathlib2
    click
    toml
    lexid
    colorama
    setuptools
  ];

  nativeCheckInputs = [
    python3.pkgs.pytestCheckHook
    git
    mercurial
  ];

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
