{
  lib,
  fetchFromGitHub,
  stdenv,
  cmake,
  gfortran,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libwignernj";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "susilehtola";
    repo = "libwignernj";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NJcLW+nFgQADOgvmYU8iNffiXYVgmTMeaUkDKbsgHAg=";
  };

  patches = [
    ./pkg-config.patch
  ];

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    gfortran
  ];

  strictDeps = true;
  __structuredAttrs = true;

  postFixup = ''
    substituteInPlace $dev/lib/cmake/wignernj/wignernjTargets.cmake --replace \
      'INTERFACE_INCLUDE_DIRECTORIES "''${_IMPORT_PREFIX}/include"' \
      'INTERFACE_INCLUDE_DIRECTORIES "${placeholder "dev"}/include"'
  '';

  meta = {
    description = "Exact evaluation of Wigner symbols and Clebsch-Gordan coefficients in C99";
    homepage = "https://github.com/susilehtola/libwignernj";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.markuskowa ];
    platforms = lib.platforms.linux;
  };
})
