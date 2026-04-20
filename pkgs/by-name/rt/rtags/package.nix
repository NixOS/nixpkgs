{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  llvmPackages,
  openssl,
  emacs,
  pkg-config,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rtags";
  version = "2.44-unstable-2026-04-12";
  nativeBuildInputs = [
    cmake
    pkg-config
    llvmPackages.llvm.dev
  ];
  buildInputs = [
    llvmPackages.llvm
    llvmPackages.libclang
    openssl
    (emacs.override { withNativeCompilation = false; })
  ]
  ++ lib.optionals stdenv.cc.isGNU [ llvmPackages.clang-unwrapped ];

  src = fetchFromGitHub {
    owner = "andersbakken";
    repo = "rtags";
    rev = "08a14ff88bf8419df62e5fbe5f04c928dd4af619";
    hash = "sha256-kE3oRf6YMT6iUDTtcKIZIdbdovduBBnyb2/6JTZ4p/k=";
    fetchSubmodules = true;
    # unicode file names lead to different checksums on HFS+ vs. other
    # filesystems because of unicode normalisation
    postFetch = ''
      rm $out/src/rct/tests/testfile_*.txt
    '';
  };

  preConfigure = ''
    export LIBCLANG_CXXFLAGS="-isystem ${llvmPackages.clang.cc}/include $(llvm-config --cxxflags) -fexceptions" \
           LIBCLANG_LIBDIR="${llvmPackages.clang.cc}/lib"
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "C/C++ client-server indexer based on clang";
    homepage = "https://github.com/andersbakken/rtags";
    license = lib.licenses.gpl3Plus;
    platforms = with lib.platforms; x86_64 ++ aarch64;
  };
})
