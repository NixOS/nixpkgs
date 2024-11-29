{ lib
, stdenv
, fetchzip
, pkg-config
, libbpf
, cmake
, elfutils
, zlib
, argp-standalone
, musl-obstack
, nixosTests
, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "pahole";
  version = "1.27";
  src = fetchzip {
    url = "https://git.kernel.org/pub/scm/devel/pahole/pahole.git/snapshot/pahole-${version}.tar.gz";
    hash = "sha256-BwA17lc2yegmOzLfoIu8OmG/PVdc+4sOGzB8Jc4ZjGM=";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ elfutils zlib libbpf ]
    ++ lib.optionals stdenv.hostPlatform.isMusl [
    argp-standalone
    musl-obstack
  ];

  patches = [
    # https://github.com/acmel/dwarves/pull/51 / https://lkml.kernel.org/r/20240626032253.3406460-1-asmadeus@codewreck.org
    ./threading-reproducibility.patch
    # https://github.com/acmel/dwarves/issues/53
    (fetchpatch {
      name = "fix-clang-btf-generation-bug.patch";
      url = "https://github.com/acmel/dwarves/commit/6a2b27c0f512619b0e7a769a18a0fb05bb3789a5.patch";
      hash = "sha256-Le1BAew/a/QKkYNLgSQxEvZ9mEEglUw8URwz1kiheeE=";
    })
    (fetchpatch {
      name = "fix-clang-btf-generation-bug-2.patch";
      url = "https://github.com/acmel/dwarves/commit/94a01bde592c555b3eb526aeb4c2ad695c5660d8.patch";
      hash = "sha256-SMIxLEBjBkprAqVNX1h7nXxAsgbwvCD/Bz7c1ekwg5w=";
    })
  ];

  # Put libraries in "lib" subdirectory, not top level of $out
  cmakeFlags = [ "-D__LIB=lib" "-DLIBBPF_EMBEDDED=OFF" ];

  passthru.tests = {
    inherit (nixosTests) bpf;
  };

  meta = with lib; {
    homepage = "https://git.kernel.org/pub/scm/devel/pahole/pahole.git/";
    description = "Shows, manipulates, and pretty-prints debugging information in DWARF, CTF, and BTF formats";
    license = licenses.gpl2Only;

    platforms = platforms.linux;
    maintainers = with maintainers; [ bosu martinetd ];
  };
}
