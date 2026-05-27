{
  lib,
  stdenv,
  fetchurl,
}:

let
  version = "0.3.0";

  archMap = {
    "x86_64-linux" = "x86_64";
    "aarch64-linux" = "aarch64";
  };
  sysArch =
    archMap.${stdenv.hostPlatform.system}
      or (throw "Unsupported architecture: ${stdenv.hostPlatform.system}");

  shimHashes = {
    "x86_64" = "sha256-7fxV/EYa/L6fLKizBRIS2Qh2/w2vG8DQmUKa1heq0ow=";
    "aarch64" = "sha256-rYcH9zAyhvXuyaO3ggI/fhOkG5hLQgj0Har0jN6dZ/w=";
  };
in
stdenv.mkDerivation {
  pname = "aerion-creds";
  inherit version;

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://github.com/hkdb/aerion/releases/download/v${version}/flathub-build-env-v${version}-linux-${sysArch}";
    hash = shimHashes.${sysArch};
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp $src $out/bin/aerion-creds
    chmod +x $out/bin/aerion-creds

    runHook postInstall
  '';

  meta = with lib; {
    description = "OAuth credentials shim for Aerion";
    homepage = "https://github.com/hkdb/aerion";
    license = licenses.asl20;
    maintainers = with maintainers; [ curious ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
