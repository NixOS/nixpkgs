{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cyclonedds";
  version = "11.1.0";

  src = fetchFromGitHub {
    owner = "eclipse-cyclonedds";
    repo = "cyclonedds";
    tag = finalAttrs.version;
    hash = "sha256-7WfSAO12tKh33q71inmlQkaziiePVW4W+H9JRHZJJ1E=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Eclipse Cyclone DDS project";
    homepage = "https://cyclonedds.io/";
    license = lib.licenses.epl20;
    maintainers = with lib.maintainers; [ bachp ];
  };
})
