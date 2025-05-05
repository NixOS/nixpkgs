{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  cmake,
  codec2,
  # for tests
  octave,
  sox,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "LPCNet";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "drowe67";
    repo = "LPCNet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tHZLKXmuM86A6OpfS3CRRjhFbqj1Q/w1w56msdgLHb0=";
  };

  passthru = {
    # Prebuilt neural network model that is needed during the build - can be overwritten
    nnmodel = fetchurl {
      url = "http://rowetel.com/downloads/deep/lpcnet_191005_v1.0.tgz";
      hash = "sha256-UJRAkkdR/dh/+qVoPuPd3ZN69cgzuRBMzOZdUWFJJsg=";
    };
  };

  preConfigure = ''
    mkdir build
    cp \
      ${finalAttrs.finalPackage.passthru.nnmodel} \
      build/${finalAttrs.finalPackage.passthru.nnmodel.name}
  '';

  prePatch = ''
    patchShebangs *.sh unittest/*.sh
  '';

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    codec2
  ];

  cmakeFlags = lib.optionals (stdenv.cc.isClang && stdenv.hostPlatform.isAarch64) [
    # unsupported option '-mfpu=' for target 'x86_64-apple-darwin'
    "-DNEON=OFF"
  ];

  nativeCheckInputs = [
    octave
    sox
  ];

  disabledTests = lib.optionals (stdenv.cc.isClang && stdenv.hostPlatform.isAarch64) [
    # disable tests that require NEON
    "SIMD_functions"
  ];

  doCheck = true;
  checkPhase = ''
    runHook preCheck

    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH''${LD_LIBRARY_PATH:+:}/build/source/build/src"

    ctest -j 1 --output-on-failure -E '^${lib.concatStringsSep "|" finalAttrs.disabledTests}$'

    runHook postCheck
  '';

  meta = {
    description = "Experimental Neural Net speech coding for FreeDV";
    homepage = "https://github.com/drowe67/LPCNet";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ doronbehar ];
    platforms = lib.platforms.all;
  };
})
