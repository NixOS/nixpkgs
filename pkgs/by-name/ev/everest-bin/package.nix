{
  lib,
  stdenvNoCC,
  fetchzip,
  icu,
  autoPatchelfHook,
}:

let
  pname = "everest";
<<<<<<< HEAD
  version = "6088";
=======
  version = "5986";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  phome = "$out/lib/Celeste";
in
stdenvNoCC.mkDerivation {
  inherit pname version;
  src = fetchzip {
<<<<<<< HEAD
    url = "https://github.com/EverestAPI/Everest/releases/download/stable-1.6088.0/main.zip";
    extension = "zip";
    hash = "sha256-npcjx7KOCe8T4MyK1d8Z485+XlvkMgjJ5m0PN5TbpgU=";
=======
    url = "https://github.com/EverestAPI/Everest/releases/download/stable-1.5986.0/main.zip";
    extension = "zip";
    hash = "sha256-SXArDyW9AzFkomsnIxoZLqZg9OWXBZG3lKI8sBffNjU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
