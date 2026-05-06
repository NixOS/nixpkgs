{
  python3Packages,
  fetchFromGitHub,
  lib,
  phylophlan,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "metaphlan";
  version = "4.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "biobakery";
    repo = "MetaPhlAn";
    tag = finalAttrs.version;
    hash = "sha256-qvjC6jozhv1dz/9eC9kEU/3OHMystX0020EyzrP71eQ=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    biom-format
    biopython
    dendropy
    h5py
    numpy
    packaging
    pandas
    pysam
    requests
    scipy
  ];

  propagateBuildInputs = [ phylophlan ];

  meta = {
    description = "Computational tool for profiling the composition of microbial communities from metagenomic shotgun sequencing data";
    homepage = "https://github.com/biobakery/MetaPhlAn";
    license = lib.licenses.mit;
    changelog = "https://github.com/biobakery/MetaPhlAn/releases/tag/${finalAttrs.src.tag}";
    mainProgram = "metaphlan";
    maintainers = with lib.maintainers; [ artur-sannikov ];
  };
})
