{ lib
, unzip
, fetchurl
, stdenvNoCC
}:

let
  appName = "Figma.app";
  dist = {
    aarch64-darwin = {
      arch = "mac-arm";
      sha256 = "sha256-HZwZ0CJx7iez0l8BAxY+NVIJhdVt0zYk42PQsuabWHg=";
    };

    x86_64-darwin = {
      arch = "mac";
      sha256 = "sha256-PccA+PJCdyXpB229nZd89P8vsycuUquxezMahe+roFU=";
    };
  }.${stdenvNoCC.hostPlatform.system} or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");

in

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "figma";
  version = "124.1.16";

  src = fetchurl {
    url = "https://desktop.figma.com/${dist.arch}/Figma-${finalAttrs.version}.zip";
    inherit (dist) sha256;
  };

  nativeBuildInputs = [ unzip ];

  dontFixup = true;

  sourceRoot = appName;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications/${appName}
    cp -r . $out/Applications/${appName}

    runHook postInstall
  '';

  meta = {
    description = "Collaborative application for interface design";
    homepage = "https://figma.com/";
    license = lib.licenses.unfree;
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ nebula ];
  };
})

