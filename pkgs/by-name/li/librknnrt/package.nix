{
  autoPatchelfHook,
  fetchurl,
  lib,
  stdenv,
}:

let
  sdkRevision = "2c723177a94fac65cbc036d722907ddbc91980cf";
  license = fetchurl {
    url = "https://raw.githubusercontent.com/airockchip/rknn-toolkit2/${sdkRevision}/LICENSE";
    hash = "sha256-0AW0qaeHrBAj/H01PZ8mMEfokrTtuSBzA5FeSim5PI4=";
  };
in
stdenv.mkDerivation {
  pname = "librknnrt";
  version = "2.5.0";

  src = fetchurl {
    url = "https://raw.githubusercontent.com/airockchip/rknn-toolkit2/${sdkRevision}/rknpu2/runtime/Linux/librknn_api/aarch64/librknnrt.so";
    hash = "sha256-S2zFdb7fiVKxPbSxGQ+js9KsIT8AvndP9szRnWUZcMA=";
  };

  dontUnpack = true;

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ stdenv.cc.cc.lib ];

  installPhase = ''
    runHook preInstall

    install -Dm755 "$src" "$out/lib/librknnrt.so"
    install -Dm644 ${license} "$out/share/licenses/librknnrt/LICENSE"

    runHook postInstall
  '';

  passthru.sdkLicense = license;

  meta = {
    description = "Rockchip NPU runtime library";
    homepage = "https://github.com/airockchip/rknn-toolkit2";
    changelog = "https://github.com/airockchip/rknn-toolkit2/releases";
    maintainers = with lib.maintainers; [ tlvince ];
    longDescription = ''
      Proprietary Rockchip RKNN SDK runtime. Distribution and use are governed
      by the license file installed in share/licenses/librknnrt/LICENSE.
    '';
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [ "aarch64-linux" ];
  };
}
