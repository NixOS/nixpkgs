{
  lib,
  stdenv,
  nixosTests,
  fetchFromGitHub,
  cmake,
  asciidoc,
  jemalloc,
  boost186,
  fmt,
  fuse3,
  spdlog,
  yaml-cpp,
  isa-l,
  judy,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "saunafs";
  version = "4.7.0";

  src = fetchFromGitHub {
    owner = "leil-io";
    repo = "saunafs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6WXSnItbydH3Lk04l0Iph14EKzL/Pl5vriWdhHxTF6I=";
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
  ];
  buildInputs = [
    fmt
    spdlog
    yaml-cpp
    fuse3
    boost186
    jemalloc
    isa-l
    judy
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
