{ lib, stdenv, fetchFromGitHub, autoconf, cmake, hdf5, zlib }:

stdenv.mkDerivation rec {
  pname = "kallisto";
<<<<<<< HEAD
  version = "0.50.0";
=======
  version = "0.48.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    repo = "kallisto";
    owner = "pachterlab";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-GJ8xMbHrnTzvPoMSczpugbIjh79cT3ngX3tLtwzlfEQ=";
=======
    sha256 = "sha256-r0cdR0jTRa1wu/LDKW6NdxI3XaKj6wcIVbIlct0fFvI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
