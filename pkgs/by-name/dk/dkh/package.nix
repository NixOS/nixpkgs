{
  lib,
  stdenv,
  gfortran,
  fetchFromGitHub,
  cmake,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "dkh";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "psi4";
    repo = "dkh";
    rev = "v${finalAttrs.version}";
    hash = "sha256-k8HZJS1y+A6nKS+7vpAwHlYX+oftBW4tzzYjl1bFZPE=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
    --replace-fail "cmake_minimum_required(VERSION 3.0)"  "cmake_minimum_required(VERSION 3.10)"
  '';

  nativeBuildInputs = [
    gfortran
    cmake
  ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" ];

  hardeningDisable = [
    "format"
  ];

  meta = {
    description = "Arbitrary-order scalar-relativistic Douglas-Kroll-Hess module";
    license = lib.licenses.lgpl3Only;
    homepage = "https://github.com/psi4/dkh";
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.sheepforce ];
  };
})
