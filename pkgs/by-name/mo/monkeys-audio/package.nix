{
  lib,
  stdenv,
  fetchzip,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "12.62";
  pname = "monkeys-audio";

  src = fetchzip {
    url = "https://monkeysaudio.com/files/MAC_${builtins.concatStringsSep "" (lib.strings.splitString "." finalAttrs.version)}_SDK.zip";
    hash = "sha256-YUY/VATJ+2bCKEdNfdvf+TQXHD7UWjd++CSZ5ut6Bs4=";
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
