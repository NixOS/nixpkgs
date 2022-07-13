{ lib, stdenv, fetchFromGitHub, cmake, zlib }:

stdenv.mkDerivation rec {
  pname = "diamond";
  version = "2.0.15";

  src = fetchFromGitHub {
    owner = "bbuchfink";
    repo = "diamond";
    rev = "v${version}";
    sha256 = "17z9vwj58i1zc22gv4qscx0dk3nxf5ix443gxsibh3a5zsnc6dkg";
  };


  nativeBuildInputs = [ cmake ];
  buildInputs = [ zlib ];

  meta = with lib; {
    description = "Accelerated BLAST compatible local sequence aligner";
    longDescription = ''
      A sequence aligner for protein and translated DNA
      searches and functions as a drop-in replacement for the NCBI BLAST
      software tools. It is suitable for protein-protein search as well as
      DNA-protein search on short reads and longer sequences including contigs
      and assemblies, providing a speedup of BLAST ranging up to x20,000.

      DIAMOND is developed by Benjamin Buchfink. Feel free to contact him for support (Email Twitter).

      If you use DIAMOND in published research, please cite
      B. Buchfink, Xie C., D. Huson,
      "Fast and sensitive protein alignment using DIAMOND",
      Nature Methods 12, 59-60 (2015).
    '';
    homepage = "https://github.com/bbuchfink/diamond";
    license = {
      fullName = "University of Tuebingen, Benjamin Buchfink";
      url = "https://raw.githubusercontent.com/bbuchfink/diamond/master/src/COPYING";
    };
    maintainers = [ ];
  };
}
