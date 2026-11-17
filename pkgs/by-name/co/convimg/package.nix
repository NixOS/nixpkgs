{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "convimg";
  version = "10.3";

  src = fetchFromGitHub {
    owner = "mateoconlechuga";
    repo = "convimg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-osLtxnugSYmIyepQzvQAOt06vTtTHd1ft9EOPuBUkXU=";
    fetchSubmodules = true;
  };

  postPatch = ''
    # As of 2026-11-17, no upstream fix for tinycthread.h colliding with glibc's once_flag/call_once
    substituteInPlace src/deps/tinycthread/source/tinycthread.h \
      --replace-fail "#define once_flag pthread_once_t" "" \
      --replace-fail "#define call_once(flag,func) pthread_once(flag,func)" ""
  '';

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  checkPhase = ''
    pushd test
    patchShebangs test.sh
    ./test.sh
    popd
  '';

  doCheck = true;

  installPhase = ''
    install -Dm755 bin/convimg $out/bin/convimg
  '';

  meta = {
    description = "Image palette quantization";
    longDescription = ''
      This program is used to convert images to other formats,
      specifically for the TI84+CE and related calculators.
    '';
    homepage = "https://github.com/mateoconlechuga/convimg";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "convimg";
  };
})
