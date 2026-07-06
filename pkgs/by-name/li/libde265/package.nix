{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,

  callPackage,

  # for passthru.tests
  imagemagick,
  libheif,
  imlib2Full,
  gst_all_1,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.1.1";
  pname = "libde265";

  src = fetchFromGitHub {
    owner = "strukturag";
    repo = "libde265";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZHfPC86oylqt2bwWMJRWVjdMEEmX6UOKR7XkR0HPyok=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  enableParallelBuilding = true;

  passthru.tests = {
    inherit imagemagick libheif imlib2Full;
    inherit (gst_all_1) gst-plugins-bad;

    test-corpus-decode = callPackage ./test-corpus-decode.nix {
      libde265 = finalAttrs.finalPackage;
    };
  };

  meta = {
    homepage = "https://github.com/strukturag/libde265";
    changelog = "https://github.com/strukturag/libde265/releases/tag/${finalAttrs.src.tag}";
    description = "Open h.265 video codec implementation";
    mainProgram = "dec265";
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
