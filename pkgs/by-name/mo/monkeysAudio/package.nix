{ lib
, stdenv
, fetchzip
, cmake
}:

stdenv.mkDerivation (finalAttrs: {
  version = "10.83";
  pname = "monkeys-audio";

  src = fetchzip {
    url = "https://monkeysaudio.com/files/MAC_${
      builtins.concatStringsSep "" (lib.strings.splitString "." finalAttrs.version)}_SDK.zip";
    hash = "sha256-QPd3YlQ2IYAqIIau3RVb2FcdE4obQjg5bZi6CUsDyHU=";
    stripRoot = false;
  };

  env.NIX_CFLAGS_COMPILE = toString [
    # Otherwise, >> related build errors are encountered
    "-std=c++11"
  ];

  nativeBuildInputs = [
    cmake
  ];

  meta = with lib; {
    description = "APE codec and decompressor";
    platforms = platforms.linux;
    mainProgram = "mac";
    license = licenses.bsd3;
    maintainers = with maintainers; [ doronbehar ];
  };
})
