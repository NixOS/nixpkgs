{ lib
, fetchFromGitHub
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "truvari";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "spiralgenetics";
    repo = "truvari";
    rev = "v${version}";
    sha256 = "1bph7v48s7pyfagz8a2fzl5fycjliqzn5lcbv3m2bp2ih1f1gd1v";
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
      --replace '"progressbar2==3.41.0",' '"progressbar2",' \
      --replace '"pysam==0.15.2",' '"pysam",' \
      --replace '"pyfaidx==0.5.5.2",' '"pyfaidx",' \
      --replace '"intervaltree==3.0.2",' '"intervaltree",'
  '';

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
