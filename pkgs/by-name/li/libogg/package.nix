{
  lib,
  stdenv,
  fetchurl,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libogg";
  version = "1.3.6";

  src = fetchurl {
    url = "http://downloads.xiph.org/releases/ogg/libogg-${finalAttrs.version}.tar.xz";
    hash = "sha256-XIJTQo4YGEDNINQfPKFlV6nMBLrUo9BMzoSAhnf6EGE=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  nativeBuildInputs = [
    # Can also be built with the `./configure` script available in the release,
    # however using cmake makes sure the resulting tree would include
    # `OggConfig.cmake` and other cmake files useful when packages try to look it
    # up with cmake.
    cmake
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
  ];

  meta = {
    description = "Media container library to manipulate Ogg files";
    longDescription = ''
      Library to work with Ogg multimedia container format.
      Ogg is flexible file storage and streaming format that supports
      plethora of codecs. Open format free for anyone to use.
    '';
    homepage = "https://xiph.org/ogg/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
  };
})
