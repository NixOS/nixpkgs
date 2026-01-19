{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  llvmPackages,
}:

stdenv.mkDerivation rec {
  pname = "muparser";
  version = "2.3.5";

  src = fetchFromGitHub {
    owner = "beltoforion";
    repo = "muparser";
    rev = "v${version}";
    hash = "sha256-CE3xgJr2RNsNMrj8Cf6xd/pD9M1OlHEclTW6xZV5X30=";
  };

  postPatch = ''
    substituteInPlace muparser.pc.in \
      --replace "\''${prefix}/@CMAKE_INSTALL_LIBDIR@" "@CMAKE_INSTALL_FULL_LIBDIR@" \
      --replace "\''${prefix}/@CMAKE_INSTALL_INCLUDEDIR@" "@CMAKE_INSTALL_FULL_INCLUDEDIR@"
  '';

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = lib.optionals stdenv.cc.isClang [
    llvmPackages.openmp
  ];

  meta = {
    description = "Extensible high performance math expression parser library written in C++";
    homepage = "https://beltoforion.de/en/muparser/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wegank ];
    platforms = lib.platforms.unix;
  };
}
