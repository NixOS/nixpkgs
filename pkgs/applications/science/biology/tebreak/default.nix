{ stdenv, fetchFromGitHub, last, exonerate, minia, python3Packages, bwa
, samtools, findutils }:

python3Packages.buildPythonApplication rec {
  pname = "tebreak";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "adamewing";
    repo = "tebreak";
    rev = version;
    sha256 = "194av17wz66n4zxyi56mbkik31j2wmkly5i9qmxgaxymhavzi3kq";
  };

  nativeBuildInputs = [ findutils python3Packages.cython ];
  propagatedBuildInputs = with python3Packages; [
    pysam
    scipy
    bx-python
    scikit-bio
  ];

  preConfigure = ''
    # patch the paths to all required software
    for f in $(find . -type f) ; do
      sed -i "s|'bwa'|'${bwa}/bin/bwa'|" $f
      sed -i "s|'minia'|'${minia}/bin/minia'|" $f
      sed -i "s|'exonerate'|'${exonerate}/bin/exonerate'|" $f
      sed -i "s|'samtools'|'${samtools}/bin/samtools'|" $f
      sed -i "s|'lastal'|'${last}/bin/lastal'|" $f
      sed -i "s|'lastdb'|'${last}/bin/lastdb'|" $f
    done
  '';

  meta = with stdenv.lib; {
    description = "Find and characterise transposable element insertions";
    homepage = "https://github.com/adamewing/tebreak";
    license = licenses.mit;
    maintainers = with maintainers; [ jbedo ];
    platforms = platforms.x86_64;
  };
}
