{
  lib,
  stdenv,
  fetchurl,
  unzip,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "angelscript";
  version = "2.38.0";

  src = fetchurl {
    url = "https://www.angelcode.com/angelscript/sdk/files/angelscript_${finalAttrs.version}.zip";
    sha256 = "sha256-sztdvNoQMX72fWKDU9gyRphM5vysEC1Nwq7RIeulLm8=";
  };

  nativeBuildInputs = [
    unzip
    cmake
  ];

  preConfigure = ''
    export ROOT=$PWD
    cd angelscript/projects/cmake
  '';

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" ];

  postInstall = ''
    mkdir -p "$out/share/docs/angelscript"
    cp -r $ROOT/docs/* "$out/share/docs/angelscript"
  '';

  meta = {
    description = "Light-weight scripting library";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.all;
    downloadPage = "https://www.angelcode.com/angelscript/downloads.html";
    homepage = "https://www.angelcode.com/angelscript/";
  };
})
