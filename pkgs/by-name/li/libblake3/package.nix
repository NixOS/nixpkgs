{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libblake3";
  version = "1.5.4";

  src = fetchFromGitHub {
    owner = "BLAKE3-team";
    repo = "BLAKE3";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-WatbhExS0j2neYsrfbNhYxrckLiXHwQBjctuowtQW+U=";
  };

  sourceRoot = finalAttrs.src.name + "/c";

  patches = [
    # Fix pkg-config for absolute CMAKE_INSTALL_*DIR
    (fetchpatch {
      url = "https://github.com/BLAKE3-team/BLAKE3/commit/aa3e8ec32a389461babde3789d6ac50ee3c38662.patch";
      hash = "sha256-V8o85EnRoqYvatqYwdr7h2TBwSOSlKrqfJWPPkQhU+c=";
      stripLen = 1;
    })
  ];

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "Official C implementation of BLAKE3";
    homepage = "https://github.com/BLAKE3-team/BLAKE3/tree/master/c";
    license = with lib.licenses; [
      asl20
      cc0
    ];
    maintainers = with lib.maintainers; [ fgaz ];
    platforms = lib.platforms.all;
  };
})
