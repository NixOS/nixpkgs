{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  eigen,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "orocos-kdl";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "orocos";
    repo = "orocos_kinematics_dynamics";
    tag = finalAttrs.version;
    hash = "sha256-4pPU+6uMMYLGq2V46wmg6lHFVhwFXrEg7PfnWGAI2is=";
    fetchSubmodules = true; # Needed to build Python bindings
  };

  sourceRoot = "${finalAttrs.src.name}/orocos_kdl";

  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [ eigen ];

  meta = {
    description = "Kinematics and Dynamics Library";
    homepage = "https://www.orocos.org/kdl.html";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ lopsided98 ];
    platforms = lib.platforms.all;
  };
})
