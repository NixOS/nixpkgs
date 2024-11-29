{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # Propagated build inputs
  portalocker,
  regex,
  tabulate,
  numpy,
  colorama,
  lxml,

  # Check inputs
  pytestCheckHook,
}:
let
  pname = "sacrebleu";
  version = "2.4.2";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mjpost";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-evSBHvDFOJlE2f9uM+NNCQeABY5lCc3Rs9dq11n7v5c=";
  };

  # postPatch = ''
  #   substituteInPlace setup.py \
  #     --replace "portalocker==" "portalocker>="
  # '';

  propagatedBuildInputs = [
    portalocker
    regex
    tabulate
    numpy
    colorama
    lxml
  ];

  checkInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # require network access
    "test/test_api.py"
    "test/test_dataset.py"
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [ "sacrebleu" ];

  meta = with lib; {
    description = "Hassle-free computation of shareable, comparable, and reproducible BLEU, chrF, and TER scores";
    mainProgram = "sacrebleu";
    homepage = "https://github.com/mjpost/sacrebleu";
    changelog = "https://github.com/mjpost/sacrebleu/blob/v{version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
  };
}
