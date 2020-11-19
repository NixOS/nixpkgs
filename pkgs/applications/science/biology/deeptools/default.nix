{ lib
, python
}:
with python.pkgs;
buildPythonApplication rec {
  pname = "deepTools";
  version = "3.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1a14a29e60be13eac11bd204dab9aef73cd72fe56a94c587333f21087584c0d8";
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

  checkInputs = [ pytest ];

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
