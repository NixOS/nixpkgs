{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  validatePkgConfig,
}:

stdenv.mkDerivation rec {
  pname = "console-bridge";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "ros";
    repo = "console_bridge";
    rev = version;
    sha256 = "sha256-M3GocT0hodw3Sc2NHcFDiPVZ1XN7BqIUuYLW8OaXMqM=";
  };

  nativeBuildInputs = [
    cmake
    validatePkgConfig
  ];

  meta = with lib; {
    description = "ROS-independent package for logging that seamlessly pipes into rosconsole/rosout for ROS-dependent packages";
    homepage = "https://github.com/ros/console_bridge";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lopsided98 ];
    platforms = platforms.all;
  };
}
