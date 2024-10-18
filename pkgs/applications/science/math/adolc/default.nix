{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "adolc";
  version = "2.7.2";

  src = fetchFromGitHub {
    owner = "coin-or";
    repo = "ADOL-C";
    sha256 = "1w0x0p32r1amfmh2lyx33j4cb5bpkwjr5z0ll43zi5wf5gsvckd1";
    rev = "releases/${version}";
  };

  configureFlags = [ "--with-openmp-flag=-fopenmp" ];

  meta = with lib; {
    description = "Automatic Differentiation of C/C++";
    homepage = "https://github.com/coin-or/ADOL-C";
    maintainers = [ maintainers.bzizou ];
    license = licenses.gpl2Plus;
  };
}

