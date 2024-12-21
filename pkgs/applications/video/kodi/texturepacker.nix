{
  stdenv, lib, fetchFromGitHub,
  cmake, makeWrapper, which, pkg-config,
  giflib, zlib, libpng, libjpeg, lzo,
  buildPackages
}:

stdenv.mkDerivation(finalAttrs: {
  pname = "kodi-texturePacker";
  version = "21.0";
  kodiReleaseName = "Omega";

  src = fetchFromGitHub {
    owner = "xbmc";
    repo  = "xbmc";
    rev   = "${finalAttrs.version}-${finalAttrs.kodiReleaseName}";
    hash  = "sha256-xrFWqgwTkurEwt3/+/e4SCM6Uk9nxuW62SrCFWWqZO0=";
  };

  sourceRoot = "source/tools/depends/native/TexturePacker/src";

  nativeBuildInputs = [
    cmake makeWrapper which pkg-config
  ];

  buildInputs = [
    giflib zlib libpng libjpeg lzo
  ];

  # Hack to set a preprocessor directive
  preConfigure = ''
      sed -i "s/find_package(JPEG REQUIRED)/find_package(JPEG REQUIRED)\nadd_definitions(-DTARGET_POSIX)/" CMakeLists.txt
    '';

  cmakeFlags = [
    "-DKODI_SOURCE_DIR=/build/source"
    "-DCMAKE_MODULE_PATH=/build/source/cmake/modules/"
  ];
})
