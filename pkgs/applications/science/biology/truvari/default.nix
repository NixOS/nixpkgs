{ lib
, fetchFromGitHub
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "truvari";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "spiralgenetics";
    repo = "truvari";
    rev = "v${version}";
    sha256 = "0wmjz8nzibvj0ixky1m0qi7iyd204prk7glbvig1cvaab33k19f1";
  };

  propagatedBuildInputs = with python3Packages; [
    pyvcf
    python-Levenshtein
    progressbar2
    pysam
    pyfaidx
    intervaltree
  ];

  prePatch = ''
    substituteInPlace ./setup.py \
      --replace '"progressbar2==3.41.0",' "" \
      --replace '"pysam==0.15.2",' ""
  '';

  meta = with lib; {
    description = "Structural variant comparison tool for VCFs";
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
