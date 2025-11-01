{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  eigen,
}:

stdenv.mkDerivation rec {
  pname = "orocos-kdl";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "orocos";
    repo = "orocos_kinematics_dynamics";
    tag = "${version}";
    hash = "sha256-4pPU+6uMMYLGq2V46wmg6lHFVhwFXrEg7PfnWGAI2is=";
    fetchSubmodules = true; # Needed to build Python bindings
  };

  sourceRoot = "${src.name}/orocos_kdl";

  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [ eigen ];

  meta = with lib; {
    description = "Kinematics and Dynamics Library";
    homepage = "https://www.orocos.org/kdl.html";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ lopsided98 ];
    platforms = platforms.all;
  };
}
