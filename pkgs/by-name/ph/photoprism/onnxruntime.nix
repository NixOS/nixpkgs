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
      "sha256-xbizzKMfPWQ6OzE7j0Li0PFqT879As2jQ9l71TBq+qs="
    else
      "sha256-zFxyuvWuXII4poQfCJcie+LQKCa5z5jq8C/e+u6wOlc=";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "photoprism-onnxruntime";
  version = "1.31.0";

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
