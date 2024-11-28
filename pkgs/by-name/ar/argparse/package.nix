{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "argparse";
  version = "3.1";

  src = fetchFromGitHub {
    owner = "p-ranav";
    repo = "argparse";
    rev = "v${version}";
    sha256 = "sha256-JH9t/e/6RaSz+3LjmuNBYOy5gJT3zA+Vz4CxuwEXlvA=";
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

  meta = with lib; {
    description = "Argument Parser for Modern C++";
    homepage    = "https://github.com/p-ranav/argparse";
    maintainers = with maintainers; [ _2gn ];
    platforms   = platforms.unix;
    license = licenses.mit;
  };
}
