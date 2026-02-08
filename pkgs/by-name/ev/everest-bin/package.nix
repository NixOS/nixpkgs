{
  lib,
  stdenvNoCC,
  fetchzip,
  icu,
  autoPatchelfHook,
}:

let
  pname = "everest";
  version = "6157";
  phome = "$out/lib/Celeste";
in
stdenvNoCC.mkDerivation {
  inherit pname version;
  src = fetchzip {
    url = "https://github.com/EverestAPI/Everest/releases/download/stable-1.6157.0/main.zip";
    extension = "zip";
    hash = "sha256-glGxQGp1zLg2wHeJBZUEbzTkCd3hU0GKBJo5SVuqXw4=";
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
    description = "Celeste mod loader (don't install; use celestegame instead)";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ ulysseszhan ];
    homepage = "https://everestapi.github.io";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };

}
