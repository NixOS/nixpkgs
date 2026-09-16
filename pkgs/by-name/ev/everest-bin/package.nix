{
  lib,
  stdenvNoCC,
  fetchzip,
  icu,
  autoPatchelfHook,
}:

let
  pname = "everest";
  version = "6531";
  phome = "$out/lib/Celeste";
in
stdenvNoCC.mkDerivation {
  inherit pname version;
  src = fetchzip {
    url = "https://github.com/EverestAPI/Everest/releases/download/stable-1.6531.0/main.zip";
    extension = "zip";
    hash = "sha256-nw/JowaUKxdPLtmnbiYEs1tWdsH1PsefrY70M+gGAvQ=";
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
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ulysseszhan ];
    homepage = "https://everestapi.github.io";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };

}
