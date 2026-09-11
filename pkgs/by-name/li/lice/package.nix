{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonPackage rec {
  pname = "lice";
  version = "0.6";
  pyproject = true;

  # github is missing tags
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LZU2YPdJiepaCH/TWNrtJiuyPlJP6t1+c3a2uHL0fmo=";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = [ python3Packages.setuptools ]; # pkg_resources

  nativeCheckInputs = [ python3Packages.pytestCheckHook ];

  meta = {
    description = "Print license based on selection and user options";
    homepage = "https://github.com/licenses/lice";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ swflint ];
    platforms = lib.platforms.unix;
    mainProgram = "lice";
  };

}
