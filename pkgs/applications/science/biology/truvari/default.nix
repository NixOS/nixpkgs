{ lib
, fetchFromGitHub
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "truvari";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "spiralgenetics";
    repo = "truvari";
    rev = "v${version}";
    sha256 = "0lp1wnldjv92k4ncga1h0icb0dpjsrx427vggg40x04a7kp9lwx0";
  };

  propagatedBuildInputs = with python3Packages; [
    pyvcf
    python-Levenshtein
    progressbar2
    pysam
    pyfaidx
    intervaltree
    pytabix
    acebinf
    bwapy
    joblib
    pandas
  ];

  # no tests
  doCheck = false;
  pythonImportsCheck = [ "truvari" ];

  meta = with lib; {
    description = "Structural variant comparison tool for VCFs";
    homepage = "https://github.com/spiralgenetics/truvari";
    license = licenses.mit;
    maintainers = with maintainers; [ scalavision ];
    longDescription = ''
      Truvari is a benchmarking tool for comparison sets of SVs.
      It can calculate the recall, precision, and f-measure of a
      vcf from a given structural variant caller. The tool
      is created by Spiral Genetics.
    '';
  };
}
