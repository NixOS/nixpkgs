{
  lib,
  stdenv,
  fetchurl,
}:

# In-tree path dependency; `src` is the whole app source.
{ version, src, ... }:

let
  # Upstream only ships ONNX Runtime for linux-x64; on other platforms the
  # build hook downloads nothing and marine life detection is disabled.
  onnxruntime-nupkg = fetchurl {
    url = "https://api.nuget.org/v3-flatcontainer/microsoft.ml.onnxruntime/1.28.0/microsoft.ml.onnxruntime.1.28.0.nupkg";
    hash = "sha256-dp0dPqirbNafc3yd1NRGKqStDM+hBur1Bu/EDXvq1ds=";
  };
in
stdenv.mkDerivation {
  pname = "submersion_vision";
  inherit version src;
  inherit (src) passthru;

  # Copy the prefetched package instead of downloading it. The hook still
  # checks the archive and the extracted library against its pinned SHA-256.
  postPatch = lib.optionalString stdenv.hostPlatform.isx86_64 ''
    substituteInPlace packages/submersion_vision/hook/build.dart \
      --replace-fail "await fetch(archive.url, fetched);" \
                     "await File('${onnxruntime-nupkg}').copy(fetched.path);"
  '';

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    cp -r . $out

    runHook postInstall
  '';
}
