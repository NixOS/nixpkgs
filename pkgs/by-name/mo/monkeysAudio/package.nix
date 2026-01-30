{
  lib,
  stdenv,
  fetchzip,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "12.05";
  pname = "monkeys-audio";

  src = fetchzip {
    url = "https://monkeysaudio.com/files/MAC_${builtins.concatStringsSep "" (lib.strings.splitString "." finalAttrs.version)}_SDK.zip";
    hash = "sha256-QmowAu/v1jqDa3MvhGlviGFZQbk7ADROLPV/R7IpsHE=";
    stripRoot = false;
  };

  env.NIX_CFLAGS_COMPILE = toString [
    # Otherwise, >> related build errors are encountered
    "-std=c++11"
  ];

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "APE codec and decompressor";
    platforms = lib.platforms.linux;
    mainProgram = "mac";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
})
