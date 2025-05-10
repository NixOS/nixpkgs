{
  lib,
  stdenvNoCC,
  fetchzip,
  icu,
  autoPatchelfHook,
}:

let
  pname = "everest";
  version = "5476";
  phome = "$out/lib/Celeste";
in
stdenvNoCC.mkDerivation {
  inherit pname version;
  src = fetchzip {
    #url = "https://github.com/EverestAPI/Everest/releases/download/stable-1.${version}.0/main.zip";
    #hash = "sha256-aEuWLR5WxYpID7ykFzgS3ZF8Mb2I+W0QIKxjfg5umj4=";
    url = "https://dev.azure.com/EverestAPI/Everest/_apis/build/builds/${
      toString (lib.toInt version - 700)
    }/artifacts?artifactName=main&api-version=7.1&%24format=zip";
    extension = "zip";
    hash = "sha256-B8VLAMdJ6NTe05I1LMcRHi1bmOWlvHXOGzoiVi+Pv9E=";
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
