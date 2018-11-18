{ stdenv, lib, fetchurl, cmake, eigen, zlib }:

stdenv.mkDerivation rec {
  pname   = "niftyseg";
  version = "1.0";
  name = "${pname}-${version}";
  src = fetchurl {
    url    = "https://github.com/KCL-BMEIS/NiftySeg/archive/v${version}.tar.gz";
    sha256 = "11q6yldsxp3k6gfp94c0xhcan2y3finzv8lzizmrc79yps3wjkn0";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ eigen zlib ];
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://cmictig.cs.ucl.ac.uk/research/software/software-nifty/niftyseg;
    description = "Software for medical image segmentation, bias field correction, and cortical thickness calculation";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.linux;
    license   = licenses.bsd3;
  };

}
