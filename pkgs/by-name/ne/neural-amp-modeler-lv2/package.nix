{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "neural-amp-modeler-lv2";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "mikeoliphant";
    repo = "neural-amp-modeler-lv2";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-TkynGmhwnkTqieJNuC+H2rDgxYZ9IFvqukfmtbSj790=";
  };

  patches = [
    # CMake 4.5 rejects the extra argument to source_group()
    (fetchpatch {
      url = "https://github.com/mikeoliphant/neural-amp-modeler-lv2/commit/20824db7c52f1d366bebd5c37b2d67b0efa96474.patch";
      hash = "sha256-t1WEAR9rCVAqS1skrPk848a33KRoq+xa/8umvVNds0o=";
    })
    # Same fix for the NeuralAudio submodule, backported to the pinned revision:
    # https://github.com/mikeoliphant/NeuralAudio/commit/ca7abf790d6b07e33768dae38252c4234e5cb9e5
    ./neuralaudio-fix-cmake-4.5-source-group.patch
  ];

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    maintainers = [
      lib.maintainers.viraptor
      lib.maintainers.gabyx
    ];
    description = "Neural Amp Modeler LV2 plugin implementation";
    homepage = finalAttrs.src.meta.homepage;
    license = lib.licenses.gpl3;
  };
})
