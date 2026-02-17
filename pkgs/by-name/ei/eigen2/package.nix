{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "eigen";
  version = "2.0.17";

  src = fetchFromGitLab {
    owner = "libeigen";
    repo = "eigen";
    rev = finalAttrs.version;
    hash = "sha256-C1Bu2H4zxd/2QVzz9AOdoCSRwOYjF41Vr/0S8Fm2kzQ=";
  };

  nativeBuildInputs = [ cmake ];

  # CMake 2.6.2 is deprecated and is no longer supported by CMake > 4
  # https://github.com/NixOS/nixpkgs/issues/445447
  patches = [ ./cmake-4-build.patch ];

  meta = {
    homepage = "https://eigen.tuxfamily.org";
    description = "C++ template library for linear algebra: vectors, matrices, and related algorithms";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [
      raskin
    ];
    platforms = lib.platforms.unix;
  };
})
