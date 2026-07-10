{
  lib,
  stdenv,
  fetchzip,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "13.13";
  pname = "monkeys-audio";

  src = fetchzip {
    url = "https://monkeysaudio.com/files/MAC_${builtins.concatStringsSep "" (lib.strings.splitString "." finalAttrs.version)}_SDK.zip";
    hash = "sha256-guXXLK0wWbuaMh57IwA9mGdAmghlh4Xk1Pt7VA9iXQY=";
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
