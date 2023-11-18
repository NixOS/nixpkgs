{ lib, stdenv, fetchFromGitHub, autoconf, cmake, hdf5, zlib }:

stdenv.mkDerivation rec {
  pname = "kallisto";
  version = "0.50.0";

  src = fetchFromGitHub {
    repo = "kallisto";
    owner = "pachterlab";
    rev = "v${version}";
    sha256 = "sha256-GJ8xMbHrnTzvPoMSczpugbIjh79cT3ngX3tLtwzlfEQ=";
  };

  nativeBuildInputs = [ autoconf cmake ];

  buildInputs = [ hdf5 zlib ];

  cmakeFlags = [ "-DUSE_HDF5=ON" ];

  # Parallel build fails in some cases: https://github.com/pachterlab/kallisto/issues/160
  enableParallelBuilding = false;

  meta = with lib; {
    description = "Program for quantifying abundances of transcripts from RNA-Seq data";
    homepage = "https://pachterlab.github.io/kallisto";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ arcadio ];
  };
}
