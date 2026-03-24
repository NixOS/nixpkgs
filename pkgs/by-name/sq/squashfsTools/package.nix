{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  help2man,
  lz4,
  lzo,
  nixosTests,
  which,
  xz,
  zlib,
  zstd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "squashfs";
  version = "4.7.5";

  src = fetchFromGitHub {
    owner = "plougher";
    repo = "squashfs-tools";
    rev = finalAttrs.version;
    hash = "sha256-rQ69sXvi6wY8yRyuQzcJZ6MvVGBbIw7vG+kYVHvfQQ8=";
  };

  patches =
    # Fixes a build failure introduced in 4.7.5. Merged upstream, drop in the next update.
    # https://github.com/plougher/squashfs-tools/pull/356
    lib.optional stdenv.hostPlatform.isDarwin (fetchpatch2 {
      name = "fix-macos-build.patch";
      url = "https://github.com/plougher/squashfs-tools/commit/f88f4a659d6ab432a57e90fe2f6191149c6b343f.patch?full_index=1";
      hash = "sha256-NyMIlL+8aU11HPH/7jTEFAQYhgMkVCgdtKytdhplCkg=";
    });

  strictDeps = true;
  nativeBuildInputs = [
    which
  ]
  # when cross-compiling help2man cannot run the cross-compiled binary
  ++ lib.optionals (stdenv.hostPlatform == stdenv.buildPlatform) [ help2man ];
  buildInputs = [
    zlib
    xz
    zstd
    lz4
    lzo
  ];

  preBuild = ''
    cd squashfs-tools
  '';

  installFlags = [
    "INSTALL_DIR=${placeholder "out"}/bin"
    "INSTALL_MANPAGES_DIR=${placeholder "out"}/share/man/man1"
  ];

  makeFlags = [
    "XZ_SUPPORT=1"
    "ZSTD_SUPPORT=1"
    "LZ4_SUPPORT=1"
    "LZMA_XZ_SUPPORT=1"
    "LZO_SUPPORT=1"
  ];

  passthru.tests = {
    nixos-iso-boots-and-verifies = nixosTests.boot.biosCdrom;
  };

  meta = {
    homepage = "https://github.com/plougher/squashfs-tools";
    description = "Tool for creating and unpacking squashfs filesystems";
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ ruuda ];
    mainProgram = "mksquashfs";
  };
})
