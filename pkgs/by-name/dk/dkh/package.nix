{
  lib,
  stdenv,
  gfortran,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "dkh";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "psi4";
    repo = pname;
    rev = "v${version}";
    sha256 = "1wb4qmb9f8rnrwnnw1gdhzx1fmhy628bxfrg56khxy3j5ljxkhck";
  };

  nativeBuildInputs = [
    gfortran
    cmake
  ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" ];

  hardeningDisable = [
    "format"
  ];

  meta = with lib; {
    description = "Arbitrary-order scalar-relativistic Douglas-Kroll-Hess module";
    license = licenses.lgpl3Only;
    homepage = "https://github.com/psi4/dkh";
    platforms = platforms.unix;
    maintainers = [ maintainers.sheepforce ];
  };
}
