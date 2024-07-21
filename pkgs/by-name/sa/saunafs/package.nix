{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  asciidoc,
  jemalloc,
  boost,
  fmt,
  fuse3,
  spdlog,
  yaml-cpp,
  isa-l,
  judy,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "saunafs";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "leil-io";
    repo = "saunafs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-T/K13JygU7Q/ylPk5ZAby3Kepi8I4z3vBBaigboJhus=";
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
    boost
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
  '';

  meta = with lib; {
    description = "Distributed POSIX file system";
    homepage = "https://saunafs.com";
    platforms = platforms.linux;
    license = licenses.gpl3Only;
    maintainers = [ maintainers.markuskowa ];
  };
})
