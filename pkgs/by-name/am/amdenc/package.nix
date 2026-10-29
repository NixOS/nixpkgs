{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
}:

let
  amdgpuVersion = "6.1.3";
  ubuntuVersion = "22.04";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "amdenc";
  version = "1.0-1787253";

  src = fetchurl {
    url = "https://repo.radeon.com/amdgpu/${amdgpuVersion}/ubuntu/pool/proprietary/liba/libamdenc-amdgpu-pro/libamdenc-amdgpu-pro_${finalAttrs.version}.${ubuntuVersion}_amd64.deb";
    hash = "sha256-RSkWQ3g++uKVrk5J9R8WA6qL0f+B2z8/mlflQ/cQZcg=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];

  buildInputs = [ (lib.getLib stdenv.cc.cc) ];

  installPhase = ''
    runHook preInstall

    install -Dm755 opt/amdgpu-pro/lib/x86_64-linux-gnu/* -t $out/lib

    runHook postInstall
  '';

  meta = {
    description = "AMD Encode Core Library";
    homepage = "https://www.amd.com/en/support/download/drivers.html";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [ jopejoe1 ];
  };
})
