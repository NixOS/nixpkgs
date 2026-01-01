{
  lib,
  stdenv,
  fetchzip,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
<<<<<<< HEAD
  version = "11.90";
=======
  version = "11.87";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "monkeys-audio";

  src = fetchzip {
    url = "https://monkeysaudio.com/files/MAC_${builtins.concatStringsSep "" (lib.strings.splitString "." finalAttrs.version)}_SDK.zip";
<<<<<<< HEAD
    hash = "sha256-S1vByCnpZPX/lfaLCPY0Cj2YXRHVtT/FzXuxebQVdRo=";
=======
    hash = "sha256-m6CG0Ar6w2fF4h3CjVsdjWWHxau2Cl3iqxh4JLH+91k=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    stripRoot = false;
  };

  env.NIX_CFLAGS_COMPILE = toString [
    # Otherwise, >> related build errors are encountered
    "-std=c++11"
  ];

  nativeBuildInputs = [
    cmake
  ];

<<<<<<< HEAD
  meta = {
    description = "APE codec and decompressor";
    platforms = lib.platforms.linux;
    mainProgram = "mac";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ doronbehar ];
=======
  meta = with lib; {
    description = "APE codec and decompressor";
    platforms = platforms.linux;
    mainProgram = "mac";
    license = licenses.bsd3;
    maintainers = with maintainers; [ doronbehar ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
})
