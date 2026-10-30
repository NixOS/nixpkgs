{
  autoPatchelfHook,
  fetchurl,
  lib,
  stdenv,
  nix-update-script,
}:

let
  platform = if stdenv.hostPlatform.isAarch64 then "aarch64" else "x64";
  hash =
    if stdenv.hostPlatform.isAarch64 then
      "sha256-5T/Az7cuUFAx4G4TxlHBy3hCTznxXTBPR6PVuQe8+fI="
    else
      "sha256-oo19ZayvwG+w9BbLQJmYdz9TFMfuv3fK+QeBKDHN/Gc=";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "photoprism-onnxruntime";
  version = "1.29.1";

  # photoprism uses yalue/onnxruntime_go which expressly requires finding a version
  # of onnxruntime whose API version matches exactly what was found at build time.
  # for ease of packaging and maximum compatibility, we'll use on photoprism's own
  # pre-built version of onnxruntime here and patch in any additional dependencies.
  src = fetchurl {
    inherit hash;
    url = "https://dl.photoprism.app/onnx/runtime/v${finalAttrs.version}/onnxruntime-linux-${platform}-${finalAttrs.version}.tgz";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    stdenv.cc.cc.lib
  ];

  installPhase = ''
    mkdir -p $out/lib
    mv lib/libonnxruntime* $out/lib/
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://photoprism.app";
    description = "Photoprism's frontend";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      ipetkov
    ];
  };
})
