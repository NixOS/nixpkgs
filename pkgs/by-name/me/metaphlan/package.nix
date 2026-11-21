{
  python3Packages,
  fetchFromGitHub,
  lib,
  bowtie2,
  phylophlan,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "metaphlan";
  version = "4.2.6";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "biobakery";
    repo = "MetaPhlAn";
    tag = finalAttrs.version;
    hash = "sha256-6GI4Alogef9VqmnB4Zs/qCSwS0CLWeCvxQ3Tgxb/R3Y=";
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
    phylophlan
    pysam
    requests
    scipy
  ];

  propagatedBuildInputs = [ bowtie2 ];

  meta = {
    description = "Computational tool for profiling the composition of microbial communities from metagenomic shotgun sequencing data";
    homepage = "https://github.com/biobakery/MetaPhlAn";
    license = lib.licenses.mit;
    changelog = "https://github.com/biobakery/MetaPhlAn/releases/tag/${finalAttrs.src.tag}";
    mainProgram = "metaphlan";
    maintainers = with lib.maintainers; [ artur-sannikov ];
  };
})
