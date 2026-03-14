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
  version = "2.44-unstable-2026-03-03";
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
    rev = "787fb682a13ca1c131c07ee28603cb1f2544595b";
    hash = "sha256-rzfCHaqfgE1t7REsl+V6gYd1wuYYKDA9zl4bak6Mlmk=";
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
