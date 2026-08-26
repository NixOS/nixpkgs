{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libunarr";
  version = "1.1.1";

  src = fetchurl {
    url = "https://github.com/selmf/unarr/releases/download/v${finalAttrs.version}/unarr-${finalAttrs.version}.tar.xz";
    hash = "sha256-Mo76BOqZbdOJFrEkeozxdqwpuFyvkhdONNMZmN5BdNI=";
  };

  patches = [
    # cmake-4 compatibility:
    #   https://github.com/selmf/unarr/pull/30
    (fetchpatch {
      name = "cmake-4.patch";
      url = "https://github.com/selmf/unarr/commit/1df8ab3d281409e9fe6bed8bf485976bb47f5bef.patch";
      hash = "sha256-u3shRgtRcHYxvXAHmYyQH1HLYV1PgWaJBY7BZCOYiL4=";
    })
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace CMakeLists.txt \
      --replace "-flto" "" \
      --replace "AppleClang" "Clang"
  '';

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    homepage = "https://github.com/selmf/unarr";
    description = "Lightweight decompression library with support for rar, tar and zip archives";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ wegank ];
    platforms = lib.platforms.unix;
  };
})
