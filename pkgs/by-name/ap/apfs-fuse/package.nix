{
  lib,
  stdenv,
  fetchFromGitHub,
  fuse,
  fuse3,
  bzip2,
  zlib,
  attr,
  cmake,
}:

stdenv.mkDerivation {
  pname = "apfs-fuse";
  version = "0-unstable-2023-03-12";

  src = fetchFromGitHub {
    owner = "sgan81";
    repo = "apfs-fuse";
    rev = "66b86bd525e8cb90f9012543be89b1f092b75cf3";
    hash = "sha256-uYAlqnQp0K880XEWuH1548DUA3ii53+hfsuh/T3Vwzg=";
    fetchSubmodules = true;
  };

  patches = [
    # fix for CMake v4
    # https://github.com/sgan81/apfs-fuse/pull/211
    ./cmake-v4.patch

    # fix for GCC 15
    # https://github.com/sgan81/apfs-fuse/pull/209
    ./add_cstdint_fix_gcc15.patch
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace CMakeLists.txt \
      --replace "/usr/local/lib/libosxfuse.dylib" "fuse"
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    (if stdenv.hostPlatform.isDarwin then fuse else fuse3)
    bzip2
    zlib
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux attr;

  cmakeFlags = lib.optional stdenv.hostPlatform.isDarwin "-DUSE_FUSE3=OFF";

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-DUSE_FUSE2";

  postFixup = ''
    ln -s $out/bin/apfs-fuse $out/bin/mount.fuse.apfs-fuse
  '';

  meta = {
    homepage = "https://github.com/sgan81/apfs-fuse";
    description = "FUSE driver for APFS (Apple File System)";
    license = lib.licenses.gpl2Plus;
    mainProgram = "apfs-fuse";
    maintainers = with lib.maintainers; [ ealasu ];
    platforms = lib.platforms.unix;
  };
}
