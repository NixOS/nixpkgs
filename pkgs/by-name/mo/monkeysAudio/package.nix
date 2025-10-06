{
  lib,
  stdenv,
  fetchzip,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "11.53";
  pname = "monkeys-audio";

  src = fetchzip {
    url = "https://monkeysaudio.com/files/MAC_${builtins.concatStringsSep "" (lib.strings.splitString "." finalAttrs.version)}_SDK.zip";
    hash = "sha256-g1I63K67upEL0in1NceayLDTQgmx4LAHd0eA0MYEp44=";
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
