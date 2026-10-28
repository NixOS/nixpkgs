{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "argparse";
  version = "3.2";

  src = fetchFromGitHub {
    owner = "p-ranav";
    repo = "argparse";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-w4IU8Yr+zPFOo7xR4YMHlqNJcEov4KU/ppDYrgsGlxM=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace '$'{CMAKE_INSTALL_LIBDIR_ARCHIND} '$'{CMAKE_INSTALL_LIBDIR}
    substituteInPlace packaging/pkgconfig.pc.in \
      --replace '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
  '';

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "Argument Parser for Modern C++";
    homepage = "https://github.com/p-ranav/argparse";
    maintainers = with lib.maintainers; [ _2gn ];
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
  };
})
