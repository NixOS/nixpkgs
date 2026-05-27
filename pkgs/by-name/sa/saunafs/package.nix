{
  lib,
  stdenv,
  nixosTests,
  fetchFromGitHub,
  cmake,
  asciidoctor,
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
  gtest,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "saunafs";
  version = "5.9.0";

  src = fetchFromGitHub {
    owner = "leil-io";
    repo = "saunafs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-OMUW5JJziW3C9R5gsnFTGnxwmVoXRTtu4aIlXfnVdME=";
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
    asciidoctor
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
    gtest
  ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_WERROR" false)
    (lib.cmakeBool "ENABLE_DOC" false)
    (lib.cmakeBool "ENABLE_CLIENT_LIB" true)
    (lib.cmakeBool "ENABLE_JEMALLOC" true)
  ];

  postInstall =
    lib.optionalString (!stdenv.hostPlatform.isStatic) ''
      rm $out/lib/*.a
    ''
    + ''
      ln -s $out/bin/sfsmount $out/bin/mount.saunafs
    '';

  passthru.tests = nixosTests.saunafs;

  meta = {
    description = "Distributed POSIX file system";
    homepage = "https://saunafs.com";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.markuskowa ];
  };
})
