{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "args";
  version = "6.4.8";

  src = fetchFromGitHub {
    owner = "Taywee";
    repo = "args";
    rev = finalAttrs.version;
    sha256 = "sha256-FUM2QXKveESKTL4svgCw/SpwHypsF7DCW+RMoTBnh3c=";
  };

  nativeBuildInputs = [ cmake ];

  # https://github.com/Taywee/args/issues/108
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace '$'{CMAKE_INSTALL_LIBDIR_ARCHIND} '$'{CMAKE_INSTALL_LIBDIR}
    substituteInPlace packaging/pkgconfig.pc.in \
      --replace '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
  '';

  meta = {
    description = "Simple header-only C++ argument parser library";
    homepage = "https://github.com/Taywee/args";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
