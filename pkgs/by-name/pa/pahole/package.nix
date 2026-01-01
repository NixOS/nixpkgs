{
  lib,
  stdenv,
  fetchzip,
  pkg-config,
  libbpf,
  cmake,
  elfutils,
  zlib,
  argp-standalone,
  musl-obstack,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "pahole";
<<<<<<< HEAD
  version = "1.31";
  src = fetchzip {
    url = "https://git.kernel.org/pub/scm/devel/pahole/pahole.git/snapshot/pahole-${version}.tar.gz";
    hash = "sha256-Afy0SysuDbTOa8H3m4hexy12Rmuv2NZL2wHfO4JtKL0=";
=======
  version = "1.30";
  src = fetchzip {
    url = "https://git.kernel.org/pub/scm/devel/pahole/pahole.git/snapshot/pahole-${version}.tar.gz";
    hash = "sha256-JF4KnI05uOlPuunJuetX/fX3ZRT6TDXdjCNG9/ufkgI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    elfutils
    zlib
    libbpf
  ]
  ++ lib.optionals stdenv.hostPlatform.isMusl [
    argp-standalone
    musl-obstack
  ];

  # Put libraries in "lib" subdirectory, not top level of $out
  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DLIBBPF_EMBEDDED=OFF"
  ];

  passthru.tests = {
    inherit (nixosTests) bpf;
  };

<<<<<<< HEAD
  meta = {
    homepage = "https://git.kernel.org/pub/scm/devel/pahole/pahole.git/";
    description = "Shows, manipulates, and pretty-prints debugging information in DWARF, CTF, and BTF formats";
    license = lib.licenses.gpl2Only;

    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    homepage = "https://git.kernel.org/pub/scm/devel/pahole/pahole.git/";
    description = "Shows, manipulates, and pretty-prints debugging information in DWARF, CTF, and BTF formats";
    license = licenses.gpl2Only;

    platforms = platforms.linux;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      bosu
      martinetd
    ];
  };
}
