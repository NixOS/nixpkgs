{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  llvmPackages,
}:

stdenv.mkDerivation rec {
  pname = "cppe";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "maxscheurer";
    repo = "cppe";
    rev = "v${version}";
    sha256 = "sha256-guM7+ZWDJLcAUJtPkKLvC4LYSA2eBvER7cgwPZ7FxHw=";
  };

  nativeBuildInputs = [ cmake ] ++ lib.optionals stdenv.cc.isClang [ llvmPackages.openmp ];

  cmakeFlags = [ "-DCMAKE_INSTALL_LIBDIR=lib" ];

  meta = with lib; {
    description = "C++ and Python library for Polarizable Embedding";
    homepage = "https://github.com/maxscheurer/cppe";
    license = licenses.lgpl3Only;
    platforms = platforms.unix;
    maintainers = [ maintainers.sheepforce ];
  };
}
