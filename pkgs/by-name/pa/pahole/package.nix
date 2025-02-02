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
  version = "1.29";
  src = fetchzip {
    url = "https://git.kernel.org/pub/scm/devel/pahole/pahole.git/snapshot/pahole-${version}.tar.gz";
    hash = "sha256-ke7WIIz0ZURw3Pgmt7WNL9WPbcv5B998Rflw/8/JQ8U=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs =
    [
      elfutils
      zlib
      libbpf
    ]
    ++ lib.optionals stdenv.hostPlatform.isMusl [
      argp-standalone
      musl-obstack
    ];

  patches = [
    # https://github.com/acmel/dwarves/pull/51 / https://lkml.kernel.org/r/20240626032253.3406460-1-asmadeus@codewreck.org
    ./threading-reproducibility.patch
  ];

  # Put libraries in "lib" subdirectory, not top level of $out
  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DLIBBPF_EMBEDDED=OFF"
  ];

  passthru.tests = {
    inherit (nixosTests) bpf;
  };

  meta = with lib; {
    homepage = "https://git.kernel.org/pub/scm/devel/pahole/pahole.git/";
    description = "Shows, manipulates, and pretty-prints debugging information in DWARF, CTF, and BTF formats";
    license = licenses.gpl2Only;

    platforms = platforms.linux;
    maintainers = with maintainers; [
      bosu
      martinetd
    ];
  };
}
