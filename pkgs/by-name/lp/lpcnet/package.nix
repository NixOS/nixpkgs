{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  cmake,
  codec2,
  sox,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "LPCNet";
  version = "0.5-unstable-2025-01-19";

  src = fetchFromGitHub {
    owner = "drowe67";
    repo = "LPCNet";
    rev = "c8e51ac5e2fe674849cb53e7da44689b572cc246";
    sha256 = "sha256-0Knoym+deTuFAyJrrD55MijVh6DlhJp3lss66BJUHiA=";
  };

  patches = [
    # extracted from https://github.com/drowe67/LPCNet/pull/59
    ./darwin.patch
  ];

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

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    codec2
  ];

  doCheck = true;
  nativeCheckInputs = [
    # NOTE: From some reason, the tests pass without this on x86_64-linux, but
    # not on aarch64-linux, although the relevant test is not enabled
    # conditionally, see:
    # https://github.com/drowe67/LPCNet/blob/c8e51ac5e2fe674849cb53e7da44689b572cc246/CMakeLists.txt#L220-L225
    sox
  ];

  meta = {
    description = "Experimental Neural Net speech coding for FreeDV";
    homepage = "https://github.com/drowe67/LPCNet";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      doronbehar
      mvs
    ];
    platforms = lib.platforms.all;
  };
})
