{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  blas,
  lapack,
}:

stdenv.mkDerivation rec {
  pname = "hmat-oss";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "jeromerobert";
    repo = "hmat-oss";
    tag = version;
    sha256 = "sha256-GnFlvZCEzSCcBVLjFWLe+AKXVA6UMs/gycrOJ2TBqrE=";
  };

  cmakeFlags = [
    "-DHMAT_GIT_VERSION=OFF"
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    blas
    lapack
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Hierarchical matrix C/C++ library";
    homepage = "https://github.com/jeromerobert/hmat-oss";
    license = licenses.gpl2;
    platforms = platforms.unix;
    # Lapack linking erros on macOS:
    # "_LAPACKE_cgeqrf", referenced from:
    #  hmat::ScalarArray<std::__1::complex<float>>::qrDecomposition(hmat::ScalarArray<std::__1::complex<float>>*, int) in scalar_array.cpp.o
    # "_LAPACKE_cgesdd", referenced from:
    # int hmat::sddCall<std::__1::complex<float>>(char, int, int, std::__1::complex<float>*, int, hmat::Types<std::__1::complex<float>>::real*, std::__1::complex<float>*, int, std::__1::complex<float>*, int) in lapack_operations.cpp.o
    broken = stdenv.hostPlatform.isDarwin;
    maintainers = with maintainers; [ gdinh ];
  };
}
