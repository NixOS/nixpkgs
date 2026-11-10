{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  makeWrapper,
  llvmPackages_21,
  flex,
  zlib,
  perlPackages,
  util-linux,
}:
let
  llvmPackages = llvmPackages_21;
in

stdenv.mkDerivation {
  pname = "creduce";
  version = "2.10.0-unstable-2024-06-01";

  src = fetchFromGitHub {
    owner = "csmith-project";
    repo = "creduce";
    rev = "31e855e290970cba0286e5032971509c0e7c0a80";
    hash = "sha256-RbxFqZegsCxnUaIIA5OfTzx1wflCPeF+enQt90VwMgA=";
  };

  patches = [
    # https://github.com/csmith-project/creduce/pull/290
    ./fix-gcc15.patch

    # support for recent llvm versions, fetched from debian which applies fixes to
    # several open PRs.
    # https://salsa.debian.org/toolchain-team/creduce/-/commit/86e45dd83b7e8e88d9e5398ff8556883c1679629
    (fetchpatch {
      name = "llvm-19-support.patch";
      url = "https://salsa.debian.org/toolchain-team/creduce/-/raw/86e45dd83b7e8e88d9e5398ff8556883c1679629/debian/patches/llvm-19-fixes.diff";
      hash = "sha256-uYjZfCJ4csnq20OHVYB7m+qboaeJkLmZm4LlsX5+hvA=";
    })
    (fetchpatch {
      name = "llvm-20-support.patch";
      url = "https://salsa.debian.org/toolchain-team/creduce/-/raw/86e45dd83b7e8e88d9e5398ff8556883c1679629/debian/patches/287.diff";
      hash = "sha256-xl9hTCgp37fRqhiYC7T/XuZkpZ3C55IZ6dSPmM81UCg=";
    })
    (fetchpatch {
      name = "llvm-21-support.patch";
      url = "https://salsa.debian.org/toolchain-team/creduce/-/raw/86e45dd83b7e8e88d9e5398ff8556883c1679629/debian/patches/289.diff";
      hash = "sha256-DSnAAxGreVGZohrWalY0/1JMo7CL8+QrMfm2tXHn2oE=";
    })
  ];

  postPatch = ''
    substituteInPlace {clex,clang_delta,delta,unifdef,creduce,.}/CMakeLists.txt --replace-fail \
    "cmake_minimum_required(VERSION 2.8.12)" "cmake_minimum_required(VERSION 3.10)"
  ''
  +
    # On Linux, c-reduce's preferred way to reason about
    # the cpu architecture/topology is to use 'lscpu',
    # so let's make sure it knows where to find it:
    lib.optionalString stdenv.hostPlatform.isLinux ''
      substituteInPlace creduce/creduce_utils.pm --replace-fail \
        lscpu ${util-linux}/bin/lscpu
    '';

  nativeBuildInputs = [
    cmake
    makeWrapper
    llvmPackages.llvm.dev
  ];
  buildInputs = [
    # Ensure stdenv's CC is on PATH before clang-unwrapped
    stdenv.cc
    # Actual deps:
    llvmPackages.llvm
    llvmPackages.libclang
    flex
    zlib
  ]
  ++ (with perlPackages; [
    perl
    ExporterLite
    FileWhich
    GetoptTabular
    RegexpCommon
    TermReadKey
  ]);

  postInstall = ''
    wrapProgram $out/bin/creduce --prefix PERL5LIB : "$PERL5LIB"
  '';

  meta = {
    description = "C program reducer";
    mainProgram = "creduce";
    homepage = "https://embed.cs.utah.edu/creduce";
    # Officially, the license is: https://github.com/csmith-project/creduce/blob/master/COPYING
    license = lib.licenses.ncsa;
    longDescription = ''
      C-Reduce is a tool that takes a large C or C++ program that has a
      property of interest (such as triggering a compiler bug) and
      automatically produces a much smaller C/C++ program that has the same
      property.  It is intended for use by people who discover and report
      bugs in compilers and other tools that process C/C++ code.
    '';
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
