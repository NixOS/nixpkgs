{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  llvmPackages,
}:

stdenv.mkDerivation rec {
  pname = "muparser";
  version = "2.3.4";

  src = fetchFromGitHub {
    owner = "beltoforion";
    repo = "muparser";
    rev = "v${version}";
    hash = "sha256-hutmmhw7BHAwbDKBiK+3Yw833GL0rPGlVjlO7XzTii0=";
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
