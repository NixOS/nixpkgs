{
  lib,
  python3Packages,
  fetchFromGitHub,
  addBinToPathHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "deeptools";
  version = "3.5.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "deeptools";
    repo = "deepTools";
    tag = version;
    hash = "sha256-dxXlOvOjF4KSc5YO+1A5hlp95sfeyPSbmp93tihm7Vo=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    numpy
    scipy
    matplotlib
    pysam
    numpydoc
    pybigwig
    py2bit
    plotly
    deeptoolsintervals
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    addBinToPathHook
  ];

  disabledTestPaths = [
    # tests trip on `len(sys.argv) == 1`
    "deeptools/test/test_bigwigAverage.py"
    "deeptools/test/test_bigwigCompare_and_multiBigwigSummary.py"
    "deeptools/test/test_heatmapper.py"
    "deeptools/test/test_multiBamSummary.py"
  ];

  meta = {
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
    license = with lib.licenses; [
      mit
      bsd3
    ];
  };
}
