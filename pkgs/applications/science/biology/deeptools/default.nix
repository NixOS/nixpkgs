{ lib, python, fetchFromGitHub }:
with python.pkgs;
buildPythonApplication rec {
  pname = "deepTools";
  version = "3.5.1";

  src = fetchFromGitHub {
    owner = "deeptools";
    repo = "deepTools";
    rev = version;
    sha256 = "07v8vb2x4b0mgw0mvcj91vj1fqbcwizwsniysl2cvmv93gad8gbp";
  };

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
  ];

  checkInputs = [ nose ];

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
    license = licenses.gpl3;
    maintainers = with maintainers; [ scalavision ];
  };
}
