{
  lib,
  stdenv,
  fetchurl,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "libunarr";
  version = "1.1.1";

  src = fetchurl {
    url = "https://github.com/selmf/unarr/releases/download/v${version}/unarr-${version}.tar.xz";
    hash = "sha256-Mo76BOqZbdOJFrEkeozxdqwpuFyvkhdONNMZmN5BdNI=";
  };

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
}
