{
  cmake,
  fetchurl,
  lib,
  libpng,
  ninja,
  stdenv,
  zlib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libsquish";
  version = "1.15";

  src = fetchurl {
    url = "mirror://sourceforge/project/libsquish/libsquish-${finalAttrs.version}.tgz";
    hash = "sha256-YoeW7rpgiGYYOmHQgNRpZ8ndpnI7wKPsUjJMhdIUcmk=";
  };
  sourceRoot = ".";

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    libpng
    zlib
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5")
  ];

  meta = {
    description = "Library for compressing images with the DXT/S3TC standard";
    longDescription = ''
      The libSquish library compresses images with the DXT standard (also known
      as S3TC). This standard is mainly used by OpenGL and DirectX for the lossy
      compression of RGBA textures.
    '';
    homepage = "https://libsquish.sourceforge.io";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.azahi ];
    platforms = lib.platforms.all;
  };
})
