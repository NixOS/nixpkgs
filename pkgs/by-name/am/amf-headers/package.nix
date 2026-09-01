{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "amf-headers";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "GPUOpen-LibrariesAndSDKs";
    repo = "AMF";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-ardO9GojOIQUnuSa2fGOCfFHI5PJYBsffCpNCh2dyRw=";
    sparseCheckout = [ "amf/public/include" ];
  };

  installPhase = ''
    mkdir -p $out/include/AMF
    cp -r amf/public/include/* $out/include/AMF
  '';

  meta = {
    description = "Headers for The Advanced Media Framework (AMF)";
    homepage = "https://github.com/GPUOpen-LibrariesAndSDKs/AMF";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ devusb ];
    platforms = lib.platforms.unix;
  };
})
