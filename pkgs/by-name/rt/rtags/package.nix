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
  version = "2.41-unstable-2025-12-29";
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
    rev = "b518bf30878d0804e95f60eb509c0bab9678eb68";
    hash = "sha256-Y5oZwVyZcIBZKv4Fwpr8jIpzVZ1Wc2SEbZoe1xw6xe8=";
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
