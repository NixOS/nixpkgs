{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libiconv,
  pkg-config,
  fuse-t-nfssrv,
  withNfssrv ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libfuse-t";
  version = "1.2.9";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "macos-fuse-t";
    repo = "libfuse";
    rev = "0daf8ea8799b82457548673fc8f2511f9b528b90";
    hash = "sha256-2dH9OLbxXU++4j8V2RkKH5RoSf+lP6VVCUlqHWbPpzU=";
  };

  outputs = [
    "out"
    "dev"
  ];

  patches = [
    # Upstream has no install rules or pkg-config file.
    ./add-install-rules.patch
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'VERSION 1.0.0' 'VERSION ${finalAttrs.version}'

    # Let stdenv pick the architecture instead of forcing a universal build.
    substituteInPlace lib/CMakeLists.txt example/CMakeLists.txt \
      --replace-fail 'set(CMAKE_OSX_ARCHITECTURES arm64;x86_64)' ""
  ''
  + lib.optionalString withNfssrv ''
    substituteInPlace lib/fuse_darwin_private.h \
      --replace-fail '"/usr/local/bin/go-nfsv4"' '"${lib.getExe fuse-t-nfssrv}"'
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = [ libiconv ];

  # Silence `pthread_setugid_np` deprecation warnings.
  env.NIX_CFLAGS_COMPILE = "-Wno-deprecated-declarations";

  postInstall = ''
    moveToOutput lib/libfuse-t.a "$dev"
  '';

  passthru.tests.hello = stdenv.mkDerivation {
    name = "libfuse-t-hello";
    inherit (finalAttrs) src;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ finalAttrs.finalPackage ];
    buildPhase = ''
      $CC -o hello example/hello.c $(pkg-config --cflags --libs fuse-t)
    '';
    installPhase = "install -Dm755 hello -t $out/bin";
  };

  meta = {
    description = "Library for FUSE-T, a kext-less FUSE implementation for macOS";
    longDescription = ''
      libfuse-t is the FUSE 2 compatible library of FUSE-T. Instead of a kernel
      extension it serves mounts through a local NFS server, `go-nfsv4`, which
      is distributed separately under an unfree license (see `fuse-t-nfssrv`).
      That server must be installed for filesystems linked against this library
      to mount anything.
    '';
    homepage = "https://github.com/macos-fuse-t/libfuse";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ bryanhonof ];
    platforms = lib.platforms.darwin;
  };
})
