{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openmesh";
  version = "11.0.0";

  src = fetchFromGitLab {
    domain = "gitlab.vci.rwth-aachen.de:9000";
    owner = "OpenMesh";
    repo = "OpenMesh";
    rev = "OpenMesh-${lib.versions.majorMinor finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-1FmAieCaskKaaAWjgEXr/CWpFxrhB2Rca1sXpxLrQHw=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://www.graphics.rwth-aachen.de/software/openmesh/";
    description = "Generic and efficient polygon mesh data structure";
    maintainers = with maintainers; [ yzx9 ];
    platforms = platforms.all;
    license = licenses.bsd3;
  };
})
