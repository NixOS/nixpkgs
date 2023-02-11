{ lib
, fetchFromGitHub
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "truvari";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "spiralgenetics";
    repo = "truvari";
    rev = "v${version}";
    sha256 = "14nsdbj063qm175xxixs34cihvsiskc9gym8pg7gbwsh13k5a00h";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'python-Levenshtein==0.12.1' 'python-Levenshtein>=0.12.1'
  '';

  propagatedBuildInputs = with python3Packages; [
    pyvcf
    levenshtein
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
