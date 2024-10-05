{
  lib,
  python3Packages,
  fetchFromGitHub,
  simde,
  zlib,
}:

python3Packages.buildPythonApplication rec {
  pname = "macs3";
  version = "3.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "macs3-project";
    repo = "MACS";
    rev = "refs/tags/v${version}";
    hash = "sha256-kiBZ3Y4JD+BzVlvmgxtGQNEUcduqri9fG85f2Al1hwY=";
  };

  postPatch = ''
    ln -s ${simde.src}/simde/* MACS3/fermi-lite/lib
  '';

  buildInputs = [ zlib ];

  build-system = with python3Packages; [
    cykhash
    cython
    hmmlearn
    numpy
    scikit-learn
    scipy
    setuptools
  ];

  dependencies = with python3Packages; [
    cykhash
    hmmlearn
    numpy
    scikit-learn
    scipy
  ];

  pythonImportsCheck = [ "MACS3" ];

  nativeCheckInputs = [ python3Packages.pytestCheckHook ];

  preCheck = ''
    rm -r MACS3
  '';

  meta = {
    description = "Model-based Analysis of ChIP-Seq";
    homepage = "https://github.com/macs3-project/MACS";
    changelog = "https://github.com/macs3-project/MACS/blob/${src.rev}/ChangeLog";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ natsukium ];
    mainProgram = "macs3";
  };
}
