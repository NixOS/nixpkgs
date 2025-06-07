{
  lib,
  stdenvNoCC,
  fetchzip,
  icu,
  autoPatchelfHook,
}:

let
  pname = "everest";
  version = "5489";
  phome = "$out/lib/Celeste";
in
stdenvNoCC.mkDerivation {
  inherit pname version;
  src = fetchzip {
    url = "https://dev.azure.com/EverestAPI/Everest/_apis/build/builds/4789/artifacts?artifactName=main&api-version=5.0&%24format=zip";
    extension = "zip";
    hash = "sha256-c4ff/og5+pf4VUUqkx5ZRxMJbABi/ynUxdNcEG582yU=";
  };
  buildInputs = [
    icu
  ];
  nativeBuildInputs = [
    autoPatchelfHook
  ];
  postInstall = ''
    mkdir -p ${phome}
    cp -r * ${phome}
  '';
  dontAutoPatchelf = true;
  dontPatchELF = true;
  dontStrip = true;
  dontPatchShebangs = true;
  postFixup = ''
    autoPatchelf ${phome}/MiniInstaller-linux
  '';
  meta = {
    description = "Celeste mod loader";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ ulysseszhan ];
    homepage = "https://everestapi.github.io";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };

}
