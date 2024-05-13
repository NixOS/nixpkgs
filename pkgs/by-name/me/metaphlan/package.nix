{ lib
, fetchFromGitHub
, fetchurl
, hclust2
, nix-update-script
, makeWrapper
, metaphlan-db
, python3
, phylophlan
}:

python3.pkgs.buildPythonApplication rec {
  pname = "metaphlan";
  version = "4.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "biobakery";
    repo = "MetaPhlAn";
    rev = "refs/tags/${version}";
    hash = "sha256-+7K5gVLRUYSulMDLszlUsKbNLNg57le63wLPtl26D8c=";
  };

  build-system = with python3.pkgs; [
    makeWrapper
    setuptools
  ];
  dependencies = with python3.pkgs; [
    metaphlan-db
    numpy
    h5py
    biom-format
    biopython
    pandas
    scipy
    hclust2
    requests
    dendropy
    pysam
    phylophlan
  ];

  makeWrapperArgs = [ "--set-default METAPHLAN_DB_DIR ${metaphlan-db}" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    changelog = "https://github.com/biobakery/MetaPhlAn/releases/tag/${version}";
    description = "MetaPhlAn is a computational tool for profiling the composition of microbial communities from metagenomic shotgun sequencing data";
    downloadPage = "https://pypi.org/project/MetaPhlAn/#files";
    homepage = "https://github.com/biobakery/MetaPhlAn";
    license = licenses.mit;
    mainProgram = "metaphlan";
    maintainers = with maintainers; [ pandapip1 ];
    inherit (python3.meta) platforms;
  };
}
