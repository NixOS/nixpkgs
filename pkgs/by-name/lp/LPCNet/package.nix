{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  cmake,
  codec2,
  # for tests
  octave,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "LPCNet";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "drowe67";
    repo = "LPCNet";
    rev = "v${finalAttrs.version}";
    hash = "sha256-tHZLKXmuM86A6OpfS3CRRjhFbqj1Q/w1w56msdgLHb0=";
  };
  passthru = {
    # Prebuilt neural network model that is needed during the build - can be overrwritten
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

  nativeBuildInputs = [ cmake ];
  buildInputs = [ codec2 ];
  nativeCheckInputs = [ octave ];

  doCheck = true;
  preCheck = ''
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH''${LD_LIBRARY_PATH:+:}/build/source/build/src"
  '';

  meta = with lib; {
    description = "Experimental Neural Net speech coding for FreeDV";
    homepage = "https://github.com/drowe67/LPCNet";
    license = licenses.bsd3;
    maintainers = with maintainers; [ doronbehar ];
    platforms = platforms.all;
  };
})
