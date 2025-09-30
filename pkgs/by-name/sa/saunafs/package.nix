{
  lib,
  stdenv,
  nixosTests,
  fetchFromGitHub,
  cmake,
  asciidoc,
  pkg-config,
  db,
  curl,
  jemalloc,
  boost186,
  fmt,
  fuse3,
  spdlog,
  yaml-cpp,
  isa-l,
  judy,
  prometheus-cpp,
  libz,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "saunafs";
  version = "5.1.2";

  src = fetchFromGitHub {
    owner = "leil-io";
    repo = "saunafs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-56PlUeXHqNhKYokKWqLCeaP3FZBdefhQFQQoP8YytQQ=";
  };

  patches = [
    ./sfstool.patch
  ];

  outputs = [
    "out"
    "man"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    asciidoc
    pkg-config
  ];
  buildInputs = [
    db
    curl
    fmt
    spdlog
    yaml-cpp
    fuse3
    boost186
    jemalloc
    isa-l
    judy
    prometheus-cpp
    libz
  ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_WERROR" false)
    (lib.cmakeBool "ENABLE_DOC" false)
    (lib.cmakeBool "ENABLE_CLIENT_LIB" true)
    (lib.cmakeBool "ENABLE_JEMALLOC" true)
  ];

  postInstall = lib.optionalString (!stdenv.hostPlatform.isStatic) ''
    rm $out/lib/*.a

    ln -s $out/bin/sfsmount $out/bin/mount.saunafs
  '';

  passthru.tests = nixosTests.saunafs;

  meta = with lib; {
    description = "Distributed POSIX file system";
    homepage = "https://saunafs.com";
    platforms = platforms.linux;
    license = licenses.gpl3Only;
    maintainers = [ maintainers.markuskowa ];
  };
})
