{ stdenv
, fetchFromGitHub
, lib
, cmake
, mpi
, blas
, lapack
, scalapack
, gfortran
} :

assert !blas.isILP64;
assert !lapack.isILP64;

stdenv.mkDerivation rec {
  pname = "libMBD";
  version = "0.12.7";

  src = fetchFromGitHub {
    owner = "libmbd";
    repo = pname;
    rev = version;
    hash = "sha256-39cvOUTAuuWLGOLdapR5trmCttCnijOWvPhSBTeTxTA=";
  };

  preConfigure = ''
    cat > cmake/libMBDVersionTag.cmake << EOF
      set(VERSION_TAG "${version}")
    EOF
  '';

  nativeBuildInputs = [ cmake gfortran ];

  buildInputs = [ blas lapack scalapack ];

  propagatedBuildInputs = [ mpi ];

  meta = with lib; {
    description = "Many-body dispersion library";
    homepage = "https://github.com/libmbd/libmbd";
    license = licenses.mpl20;
    platforms = platforms.linux;
    maintainers = [ maintainers.sheepforce ];
  };
}
