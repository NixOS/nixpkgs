{
  lib,
  stdenv,
  orthanc,
  gtest,
  icu,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "orthanc-framework";
  inherit (orthanc)
    src
    version
    nativeBuildInputs
    strictDeps
    cmakeFlags
    ;

  sourceRoot = "${finalAttrs.src.name}/OrthancFramework/SharedLibrary";
  outputs = [
    "out"
    "dev"
  ];

  buildInputs = orthanc.buildInputs ++ [
    icu
  ];

  NIX_LDFLAGS = lib.strings.concatStringsSep " " [
    "-L${lib.getLib zlib}"
    "-lz"
    "-L${lib.getLib gtest}"
    "-lgtest"
  ];

  meta = {
    description = "SDK for building Orthanc plugins and related applications";
    homepage = "https://www.orthanc-server.com/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ drupol ];
    platforms = lib.platforms.linux;
  };
})
