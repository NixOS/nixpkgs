{
  lib,
  fetchFromGitHub,
  raxml,
  mafft,
  trimal,
  blast,
  diamond,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "phylophlan";
  version = "3.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "biobakery";
    repo = "phylophlan";
    tag = finalAttrs.version;
    hash = "sha256-rPTEdu0W3LD27tDIWCOQ3K+RJuj97I9aEeYFdM77jOs=";
  };

  build-system = with python3Packages; [ setuptools ];

  # It has no tests
  doCheck = false;

  dependencies = with python3Packages; [
    biopython
    dendropy
    matplotlib
    numpy
    pandas
    seaborn
    distutils
    requests
    scipy
    tqdm
  ];

  preFixup = ''
    # Minimum needed external tools
    # See https://github.com/biobakery/phylophlan/wiki#dependencies
    makeWrapperArgs+=(--prefix PATH : ${
      lib.makeBinPath [
        raxml
        mafft
        trimal
        blast
        diamond
      ]
    }
    )
  '';

  postInstall = ''
    # Not revelant in this context
    rm -f $out/bin/phylophlan_write_default_configs.sh
  '';

  meta = {
    homepage = "https://github.com/biobakery/phylophlan";
    description = "Precise phylogenetic analysis of microbial isolates and genomes from metagenomes";
    changelog = "https://github.com/biobakery/phylophlan/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ theobori ];
    mainProgram = "phylophlan";
  };
})
