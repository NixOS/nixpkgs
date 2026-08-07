{
  lib,
  stdenv,
  fetchurl,
}:

let
  version = "0.3.2";

  archMap = {
    "x86_64-linux" = "x86_64";
    "aarch64-linux" = "aarch64";
  };
  sysArch =
    archMap.${stdenv.hostPlatform.system}
      or (throw "Unsupported architecture: ${stdenv.hostPlatform.system}");

  shimHashes = {
    "x86_64" = "sha256-8WvuQgWTJNe4UpmS6uSYDYm46sIqxJbwVZ/J3CRz0OI=";
    "aarch64" = "sha256-4RvFbxJGwM70huziY2ELoCouTrtMasgoqFUncBeBFvU=";
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

  meta = {
    description = "OAuth credentials shim for Aerion";
    homepage = "https://github.com/hkdb/aerion";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ curious ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
