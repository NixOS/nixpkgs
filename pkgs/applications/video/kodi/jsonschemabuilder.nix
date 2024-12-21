{
  stdenv, lib, fetchFromGitHub,
  cmake, makeWrapper, which, pkg-config,
  buildPackages
}:

stdenv.mkDerivation(finalAttrs: {
  pname = "kodi-jsonSchemaBuilder";
  version = "21.0";
  kodiReleaseName = "Omega";

  src = fetchFromGitHub {
    owner = "xbmc";
    repo  = "xbmc";
    rev   = "${finalAttrs.version}-${finalAttrs.kodiReleaseName}";
    hash  = "sha256-xrFWqgwTkurEwt3/+/e4SCM6Uk9nxuW62SrCFWWqZO0=";
  };

  sourceRoot = "source/tools/depends/native/JsonSchemaBuilder/src";

  nativeBuildInputs = [
    cmake makeWrapper which pkg-config
  ];

  cmakeFlags = [
    "-DKODI_SOURCE_DIR=/build/source"
    "-DCMAKE_MODULE_PATH=/build/source/cmake/modules/"
  ];
})
