{ lib, python, fetchFromGitHub }:
with python.pkgs;
buildPythonApplication rec {
  pname = "deepTools";
  version = "3.5.4";

  src = fetchFromGitHub {
    owner = "deeptools";
    repo = "deepTools";
    rev = version;
    sha256 = "sha256-A8YdlMptmJyxWW0EYLjXFIWjIO/mttEC7VYdlCe9MaI=";
  };

  format = "pyproject";

  propagatedBuildInputs = [
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

  nativeCheckInputs = [ pytest ];

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
    license = with licenses; [ mit bsd3 ];
    maintainers = with maintainers; [ scalavision ];
  };
}
