{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  cmake,
  tcl,
  swig,
  bison,
  flex,
  cudd,
  eigen,
  libzip,
}:

stdenv.mkDerivation {
  pname = "opensta";
  version = "0-unstable-2025-04-24";

  src = fetchFromGitHub {
    owner = "parallaxsw";
    repo = "OpenSTA";
    rev = "eb8d39a7dd81b5ca2582ad9bbce0fb6e094b3e0f";
    hash = "sha256-heOyVVqY6cQCiBI8IOQMTy0pSIF5C2/9CKe0S6Q77C4=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    swig
    tcl
    bison
    flex
  ];

  buildInputs = [
    libzip
    tcl
    eigen
    cudd
    flex
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "A gate‑level static timing verifier";
    homepage = "https://github.com/parallaxsw/OpenSTA";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.fayalalebrun ];
    platforms = lib.platforms.unix;
  };
}
