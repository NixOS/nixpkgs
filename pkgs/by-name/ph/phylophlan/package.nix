{ lib
, fetchFromGitHub
, nix-update-script
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "phylophlan";
  version = "3.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "biobakery";
    repo = "phylophlan";
    rev = "refs/tags/${version}";
    hash = "sha256-KlWKt2tH2lQBh/eQ2Hbcu2gXHEFfmFEc6LrybluxINc=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    biopython
    dendropy
    matplotlib
    numpy
    pandas
    seaborn
    requests
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    changelog = "https://github.com/biobakery/phylophlan/releases/tag/${version}";
    description = "Precise phylogenetic analysis of microbial isolates and genomes from metagenomes";
    downloadPage = "https://pypi.org/project/PhyloPhlAn/#files";
    homepage = "https://github.com/biobakery/phylophlan";
    license = licenses.mit;
    mainProgram = "phylophlan";
    maintainers = with maintainers; [ pandapip1 ];
    inherit (python3.meta) platforms;
  };
}
