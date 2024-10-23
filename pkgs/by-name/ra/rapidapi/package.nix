{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rapidapi";
  version = "4.2.6-4002006002";

  src = fetchurl {
    url = "https://cdn-builds.paw.cloud/paw/RapidAPI-${finalAttrs.version}.zip";
    hash = "sha256-Yz4xNSvxqcQjZqbXkyTAE+lWnP3SkKraqmueFTBBk8Y=";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;
  dontUnpack = true;

  nativeBuildInputs = [ unzip ];

  sourceRoot = "RapidAPI.app";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    unzip -d $out/Applications $src

    runHook postInstall
  '';

  meta = {
    description = "Full-featured HTTP client that lets you test and describe the APIs you build or consume";
    homepage = "https://paw.cloud";
    changelog = "https://paw.cloud/updates/${lib.head (lib.splitString "-" finalAttrs.version)}";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ DimitarNestorov ];
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
    ];
  };
})
