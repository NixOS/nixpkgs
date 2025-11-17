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
  version = "2.41-unstable-2025-11-08";
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
    rev = "18351b67cd770868d8a053279be26149c374abb6";
    hash = "sha256-6xW5lBAyxGPdPwCCEm363ciL3PA5WRUQU2efi5fc58U=";
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
