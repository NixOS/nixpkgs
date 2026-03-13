{
  lib,
  stdenv,
  fetchFromGitHub,
  gmp,
  installShellFiles,
  versionCheckHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "prst";
  version = "13.3";

  src = fetchFromGitHub {
    owner = "patnashev";
    repo = "prst";
    tag = "v${finalAttrs.version}";
    hash = "sha256-J+45JwkA/z3HmzO9J6RVVXutUAVSzOXDMkyUR3zSh9E=";
    fetchSubmodules = true;
  };

  enableParallelBuilding = true;

  strictDeps = true;

  buildInputs = [ gmp ];

  nativeBuildInputs = [ installShellFiles ];

  # add #include <cstdint>
  # remove static flag
  postPatch = ''
    for f in framework/arithmetic/*.h; do
      sed -i '1i #include <cstdint>' "$f"
    done

    substituteInPlace src/linux64/Makefile \
      --replace-fail "-static" "" \
  '';

  makeFlags = [
    "-C"
    "src/linux64"
  ];

  installPhase = ''
    runHook preInstall

    installBin src/linux64/prst

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  versionCheckProgramArg = "-v";

  meta = {
    description = "Primality testing utility written in C++";
    longDescription = ''
      This utility is best used for systematic searches of large prime numbers, either by public distributed projects or by private individuals.
      It can handle numbers of many popular forms like Proth numbers, Thabit numbers, generalized Fermat numbers, factorials, primorials and arbitrary numbers.
      Mersenne numbers are better handled by GIMPS.
      It is assumed that input candiates are previously sieved by a sieving utility best suited for the specific form of numbers.
    '';
    homepage = "https://github.com/patnashev/prst";
    maintainers = with lib.maintainers; [ dstremur ];
    license = lib.licenses.unfree;
    # PRST links against gwnum.a which is part of the proprietary gwnum library,
    # making the resulting binary unfree even though the PRST source code itself
    # may have different licensing terms.
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "prst";
  };
})
