{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  llvmPackages,
  openssl,
  emacs,
  pkg-config,
  darwin,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rtags";
  version = "2.46";
  nativeBuildInputs = [
    cmake
    pkg-config
    llvmPackages.llvm.dev
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.DarwinTools
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
    tag = "v${finalAttrs.version}";
    hash = "sha256-uibS9Jg9jtniiZMtc5pCauT3kbBCL2uuYjXso5wBn1w=";
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "C/C++ client-server indexer based on clang";
    homepage = "https://github.com/andersbakken/rtags";
    license = lib.licenses.gpl3Plus;
    platforms = with lib.platforms; x86_64 ++ aarch64;
  };
})
