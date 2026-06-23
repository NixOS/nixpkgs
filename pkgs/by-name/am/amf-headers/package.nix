{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "amf-headers";
  version = "1.5.2";

  src = fetchurl {
    url = "https://github.com/GPUOpen-LibrariesAndSDKs/AMF/releases/download/v${finalAttrs.version}/AMF-headers-v${finalAttrs.version}.tar.gz";
    hash = "sha256-08EusyTt8F4hRgi2o5WlHdlXcO2dRVIBhdbDogaBHJk=";
  };

  installPhase = ''
    mkdir -p $out/include/AMF
    cp -r AMF $out/include
  '';

  meta = {
    description = "Headers for The Advanced Media Framework (AMF)";
    homepage = "https://github.com/GPUOpen-LibrariesAndSDKs/AMF";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ devusb ];
    platforms = lib.platforms.unix;
  };
})
