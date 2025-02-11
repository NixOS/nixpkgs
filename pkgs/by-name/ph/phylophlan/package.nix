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
let
  finalAttrs = {
    pname = "phylophlan";
    version = "3.1.1";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "biobakery";
      repo = "phylophlan";
      rev = "refs/tags/${finalAttrs.version}";
      hash = "sha256-KlWKt2tH2lQBh/eQ2Hbcu2gXHEFfmFEc6LrybluxINc=";
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
    ];

    # Minimum needed external tools
    # See https://github.com/biobakery/phylophlan/wiki#dependencies
    propagatedBuildInputs = [
      raxml
      mafft
      trimal
      blast
      diamond
    ];

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
  };
in
python3Packages.buildPythonApplication finalAttrs
