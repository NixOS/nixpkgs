{
  lib,
  stdenv,
  fetchFromGitHub,
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
