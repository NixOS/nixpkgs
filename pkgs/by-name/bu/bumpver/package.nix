{
  lib,
  python3,
  fetchPypi,
  git,
  mercurial,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "bumpver";
  version = "2026.1132";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    sha256 = "sha256-gLIjwj/Km8ndVpt6RGgJSdNL7iOnOIYNmps28avjsOA=";
  };

  prePatch = ''
    substituteInPlace setup.py \
      --replace-fail "if any(arg.startswith(\"bdist\") for arg in sys.argv):" ""\
      --replace-fail "import lib3to6" ""\
      --replace-fail "package_dir = lib3to6.fix(package_dir)" ""

    patchShebangs test/fixtures/hooks
  '';

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    click
    toml
    lexid
    colorama
  ];

  nativeCheckInputs = [
    python3.pkgs.pytestCheckHook
    git
    mercurial
  ];

  meta = {
    description = "Bump version numbers in project files";
    homepage = "https://pypi.org/project/bumpver/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kfollesdal ];
    mainProgram = "bumpver";
  };
})
