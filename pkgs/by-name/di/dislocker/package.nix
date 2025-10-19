{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  mbedtls_2,
  fuse,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dislocker";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "Aorimn";
    repo = "dislocker";
    tag = "v${finalAttrs.version}";
    hash = "sha256-U8BD3kE1CH+Mjh/7SlXG9gKY6/LyF9+ER5C3soNGZqo=";
  };

  patches = [
    # This patch
    #   1. adds support for the latest FUSE on macOS
    #   2. uses pkg-config to find libfuse instead of searching in predetermined
    #      paths
    #
    # https://github.com/Aorimn/dislocker/pull/246
    (fetchpatch {
      name = "feat-support-the-latest-FUSE-on-macOS.patch";
      url = "https://github.com/Aorimn/dislocker/commit/7744f87c75fcfeeb414d0957771042b10fb64e62.patch";
      hash = "sha256-JX+4DJLcw9qP1nIs+sZDcduSFvU4YdGyblFLtxZj/i4=";
    })
    # fix compatibility with CMake (https://cmake.org/cmake/help/v4.0/command/cmake_minimum_required.html)
    # https://github.com/Aorimn/dislocker/pull/346
    (fetchpatch {
      name = "cmake-raise-minimum-required-version-to-3.5.patch";
      url = "https://github.com/Aorimn/dislocker/commit/337d05dc7447436539f2fb481eef0e528a000b66.patch";
      hash = "sha256-6LTRjaZfyGS2BCdpcJy/qo0r8soXJSZqWjZRbaKvcQk=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    fuse
    mbedtls_2
  ];

  meta = {
    description = "Read BitLocker encrypted partitions in Linux";
    homepage = "https://github.com/Aorimn/dislocker";
    changelog = "https://github.com/Aorimn/dislocker/raw/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ elitak ];
    platforms = lib.platforms.unix;
  };
})
