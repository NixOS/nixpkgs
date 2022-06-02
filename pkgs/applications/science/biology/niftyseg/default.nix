{ lib, stdenv, fetchFromGitHub, cmake, eigen, zlib }:

stdenv.mkDerivation rec {
  pname   = "niftyseg";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "KCL-BMEIS";
    repo = "NiftySeg";
    rev = "v${version}";
    sha256 = "sha256-FDthq1ild9XOw3E3O7Lpfn6hBF1Frhv1NxfEA8500n8=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ eigen zlib ];

  meta = with lib; {
    homepage = "http://cmictig.cs.ucl.ac.uk/research/software/software-nifty/niftyseg";
    description = "Software for medical image segmentation, bias field correction, and cortical thickness calculation";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
    license   = licenses.bsd3;
  };

}
