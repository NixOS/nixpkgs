{
  lib,
  stdenv,
  zlib,
  autoreconfHook,
  fetchpatch,
}:

stdenv.mkDerivation {
  pname = "minizip";
  inherit (zlib) src version;

  patches = [
    # install missing header for qtwebengine:
    #   https://github.com/madler/zlib/pull/1178
    (fetchpatch {
      name = "add-int.h.patch";
      url = "https://github.com/madler/zlib/commit/cb14dc9ade3759352417a300e6c2ed73268f1d97.patch";
      hash = "sha256-eX06nYLRPqpkbBAOso1ynGDYs9dcRAI14cG89qXuUzo=";
    })
  ];

  patchFlags = [ "-p3" ];

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ zlib ];

  sourceRoot = "zlib-${zlib.version}/contrib/minizip";

  meta = {
    description = "Compression library implementing the deflate compression method found in gzip and PKZIP";
    inherit (zlib.meta) license homepage;
    platforms = lib.platforms.unix;
  };
}
