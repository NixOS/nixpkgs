{
  stdenvNoCC,
  lib,
  fetchurl,
  unzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "realm-studio";
  version = "15.2.1";

  src = fetchurl {
    url = "https://static.realm.io/downloads/realm-studio/Realm%20Studio-${finalAttrs.version}-mac.zip";
    hash = "sha256-Vvc432P7VQxCVcS7i7JwOx7ByhX+Ea0Oz7ogvAH8Xoo=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -r "Realm Studio.app" $out/Applications/
    runHook postInstall
  '';

  meta = {
    description = "Visual tool to view, edit, and model Realm databases";
    homepage = "https://www.mongodb.com/docs/atlas/device-sdks/studio/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ matteopacini ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
