{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "args";
  version = "6.4.7";

  src = fetchFromGitHub {
    owner = "Taywee";
    repo = "args";
    rev = version;
    sha256 = "sha256-IQzhbXl1CfEV164EjulKrOUdCTZNZAFgVyzxk4rTNlU=";
  };

  nativeBuildInputs = [ cmake ];

  # https://github.com/Taywee/args/issues/108
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace '$'{CMAKE_INSTALL_LIBDIR_ARCHIND} '$'{CMAKE_INSTALL_LIBDIR}
    substituteInPlace packaging/pkgconfig.pc.in \
      --replace '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
  '';

  meta = with lib; {
    description = "Simple header-only C++ argument parser library";
    homepage = "https://github.com/Taywee/args";
    license = licenses.mit;
    maintainers = [ ];
  };
}
