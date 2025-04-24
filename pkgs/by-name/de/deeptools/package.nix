{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "deeptools";
  version = "3.5.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "deeptools";
    repo = "deepTools";
    rev = "refs/tags/${version}";
    hash = "sha256-2kSlL7Y5f/FjVtStnmz+GlTw2oymrtxOCaXlqgbQ7FU=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
  ];

  propagatedBuildInputs = with python3.pkgs; [
    numpy
    numpydoc
    scipy
    py2bit
    pybigwig
    pysam
    matplotlib
    plotly
    deeptoolsintervals
    importlib-metadata
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  preCheck = ''
    export PATH="$out/bin:$PATH"
  '';

  disabledTestPaths = [
    # tests trip on `len(sys.argv) == 1`
    "deeptools/test/test_bigwigAverage.py"
    "deeptools/test/test_bigwigCompare_and_multiBigwigSummary.py"
    "deeptools/test/test_heatmapper.py"
    "deeptools/test/test_multiBamSummary.py"
  ];

  meta = with lib; {
    homepage = "https://deeptools.readthedocs.io/en/develop";
    description = "Tools for exploring deep DNA sequencing data";
    longDescription = ''
      deepTools contains useful modules to process the mapped reads data for multiple
      quality checks, creating normalized coverage files in standard bedGraph and bigWig
      file formats, that allow comparison between different files (for example, treatment and control).
      Finally, using such normalized and standardized files, deepTools can create many
      publication-ready visualizations to identify enrichments and for functional
      annotations of the genome.
    '';
    license = with licenses; [
      mit
      bsd3
    ];
    maintainers = with maintainers; [ scalavision ];
  };
}
