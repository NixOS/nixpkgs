{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "neural-amp-modeler-lv2";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "mikeoliphant";
    repo = finalAttrs.pname;
    rev = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-sRZngmivNvSWcjkIqcqjjaIgXFH8aMq+/caNroXmzIk=";
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
