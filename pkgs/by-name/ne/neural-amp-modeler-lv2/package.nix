{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "neural-amp-modeler-lv2";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "mikeoliphant";
    repo = "neural-amp-modeler-lv2";
    rev = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-5BOZOocZWWSWawXJFMAgM0NR0s0CbkzDVr6fnvZMvd0=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    maintainers = [ lib.maintainers.viraptor ];
    description = "Neural Amp Modeler LV2 plugin implementation";
    homepage = finalAttrs.src.meta.homepage;
    license = [ lib.licenses.gpl3 ];
  };
})
