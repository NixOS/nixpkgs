{
  lib,
  stdenv,
  python3,
  src,
  patches,
  threadSanitizer ? false,
}:
stdenv.mkDerivation {
  pname = "openmpi-ucx-fence-control";
  version = "1";
  inherit src patches;
  nativeBuildInputs = [ python3 ];
  dontConfigure = true;
  buildPhase = ''
    runHook preBuild
    python3 ${./ucx-fence-control.py} > ucx-fence-control.c
    timeout 120 $CC -std=c11 -O2 -Wall -pthread \
      ${lib.optionalString threadSanitizer "-g -fsanitize=thread -no-pie"} \
      ucx-fence-control.c -o ucx-fence-control
    ${lib.optionalString threadSanitizer "export TSAN_OPTIONS=halt_on_error=1"}
    timeout 30 ./ucx-fence-control > results.json
    runHook postBuild
  '';
  installPhase = ''
    mkdir -p "$out"
    cp results.json "$out/"
  '';
}
