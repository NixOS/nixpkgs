{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  libdrm,
  amdenc,
  autoPatchelfHook,
}:

let
  amdgpuVersion = "6.1.3";
  ubuntuVersion = "22.04";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "amf";
  version = "1.4.34-1787253";

  src = fetchurl {
    url = "https://repo.radeon.com/amdgpu/${amdgpuVersion}/ubuntu/pool/proprietary/a/amf-amdgpu-pro/amf-amdgpu-pro_${finalAttrs.version}.${ubuntuVersion}_amd64.deb";
    hash = "sha256-5sMI0ktqQDTu5xOKP9T9vjaSIHQizF1wHhqJcVnY40c=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];

  buildInputs = [
    libdrm
    amdenc
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 opt/amdgpu-pro/lib/x86_64-linux-gnu/* -t $out/lib

    runHook postInstall
  '';

  preFixup = ''
    patchelf $out/lib/* --add-needed libamdenc64.so
  '';

  meta = {
    description = "AMD's closed source Advanced Media Framework (AMF) driver";
    homepage = "https://www.amd.com/en/support/download/drivers.html";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [ jopejoe1 ];
  };
})
