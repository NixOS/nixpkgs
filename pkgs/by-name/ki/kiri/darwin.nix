{
  lib,
  stdenvNoCC,
  fetchurl,
  version,
  meta,
  passthru,
}:

let
  sources = {
    aarch64-darwin = fetchurl {
      url = "https://github.com/libracoder/kiri/releases/download/v${version}/Kiri-${version}-arm64.tar.gz";
      hash = "sha256-e+HCiwjy50rC70+JcqPalR+JpONfEKRh3Oyw+tm5SvI=";
    };
  };
in
stdenvNoCC.mkDerivation {
  pname = "kiri";
  __structuredAttrs = true;
  inherit version passthru;

  src =
    sources.${stdenvNoCC.hostPlatform.system}
      or (throw "kiri: unsupported system ${stdenvNoCC.hostPlatform.system}");

  sourceRoot = ".";

  # The bundle is signed and notarized with the virtualization entitlement:
  # stripping or rewriting anything inside it would break the signature.
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall
    # The tarball carries AppleDouble files that only macOS tar folds back
    # into xattrs; left as files they invalidate the bundle's sealed resources.
    find Kiri.app -name '._*' -delete
    mkdir -p $out/Applications $out/bin
    cp -R Kiri.app $out/Applications/
    # kiri canonicalizes its own path to find Contents/Resources/guest.
    ln -s $out/Applications/Kiri.app/Contents/MacOS/kiri $out/bin/kiri
    runHook postInstall
  '';

  meta = meta // {
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = builtins.attrNames sources;
  };
}
