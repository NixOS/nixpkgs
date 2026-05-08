{
  lib,
  stdenv,
  fetchzip,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "12.84";
  pname = "monkeys-audio";

  src = fetchzip {
    url = "https://monkeysaudio.com/files/MAC_${builtins.concatStringsSep "" (lib.strings.splitString "." finalAttrs.version)}_SDK.zip";
    hash = "sha256-WYBc59DJM5DVe7hZVXCsMJsShUQf8Ib0OLKISRjg4pY=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "APE codec and decompressor";
    platforms = with lib.platforms; linux ++ windows ++ darwin;
    mainProgram = "mac";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
})
