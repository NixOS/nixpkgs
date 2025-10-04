{
  stdenv,
  lib,
  fetchurl,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "libhugetlbfs";
  version = "2.24";

  src = fetchurl {
    url = "https://github.com/libhugetlbfs/libhugetlbfs/releases/download/${version}/libhugetlbfs-${version}.tar.gz";
    hash = "sha256-1QHfqRyOrREGlno9OCnyunOMP6wKZcs1jtKrOHDdxe8=";
  };

  outputs = [
    "bin"
    "dev"
    "man"
    "doc"
    "lib"
    "out"
  ];

  nativeBuildInputs = [ autoreconfHook ];

  postConfigure = ''
    patchShebangs ld.hugetlbfs
  '';

  enableParallelBuilding = true;
  makeFlags = [
    "BUILDTYPE=NATIVEONLY"
    "PREFIX=$(out)"
    "HEADERDIR=$(dev)/include"
    "LIBDIR32=$(lib)/$(LIB32)"
    "LIBDIR64=$(lib)/$(LIB64)"
    "EXEDIR=$(bin)/bin"
    "DOCDIR=$(doc)/share/doc/libhugetlbfs"
    "MANDIR=$(man)/share/man"
  ]
  ++ lib.optionals (stdenv.buildPlatform.system != stdenv.hostPlatform.system) [
    # The ARCH logic defaults to querying `uname`, which will return build platform arch
    "ARCH=${stdenv.hostPlatform.uname.processor}"
  ];

  # Default target builds tests as well, and the tests want a static
  # libc.
  buildFlags = [
    "libs"
    "tools"
  ];
  installTargets = [
    "install"
    "install-docs"
  ];

  meta = {
    homepage = "https://github.com/libhugetlbfs/libhugetlbfs";
    changelog = "https://github.com/libhugetlbfs/libhugetlbfs/blob/${version}/NEWS";
    description = "Library and utilities for Linux hugepages";
    maintainers = with lib.maintainers; [ qyliss ];
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    badPlatforms = lib.flatten [
      lib.systems.inspect.platformPatterns.isStatic
      lib.systems.inspect.patterns.isMusl
    ];
  };
}
