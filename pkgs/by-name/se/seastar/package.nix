{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  boost,
  c-ares,
  fmt_11,
  lz4,
  gnutls,
  hwloc,
  lksctp-tools,
  yaml-cpp,
  protobuf,
  ragel,
  valgrind,
  openssl,
  doxygen,
  python3,
  xfsprogs,
  liburing,
  useIoUring ? true,
}:
stdenv.mkDerivation rec {
  pname = "seastar";
  version = "25.05.0";

  nativeBuildInputs = [
    cmake
    pkg-config
    ragel
    valgrind
    openssl
    doxygen
    python3
  ];

  buildInputs = [
    boost
    c-ares
    fmt_11
    lz4
    gnutls
    hwloc
    lksctp-tools
    yaml-cpp
    protobuf
    xfsprogs
  ]
  ++ lib.optional useIoUring liburing;

  postPatch = ''
    patchShebangs scripts

    substituteInPlace CMakeLists.txt \
      --replace-fail '$'"{CMAKE_INSTALL_PREFIX}/"'$'"{CMAKE_INSTALL_LIBDIR}" '$'"{CMAKE_INSTALL_FULL_LIBDIR}" \
      --replace-fail "-I"'$'"{CMAKE_INSTALL_PREFIX}/"'$'"{CMAKE_INSTALL_INCLUDEDIR}" '$'"{CMAKE_INSTALL_FULL_INCLUDEDIR}"
  '';

  src = fetchFromGitHub {
    owner = "scylladb";
    repo = "seastar";
    tag = "seastar-${version}";
    hash = "sha256-d8n+razhGQZ9YV37Fp0RzKC0DHdwnohe87PgVSkymGA=";
  };

  cmakeFlags = lib.optional useIoUring (lib.cmakeBool "Seastar_IO_URING" true);

  meta = with lib; {
    description = "High performance server-side application framework";
    homepage = "https://github.com/scylladb/seastar";
    changelog = "https://github.com/scylladb/seastar/releases/tag/seastar-${src.tag}";
    license = licenses.asl20;
  };
}
