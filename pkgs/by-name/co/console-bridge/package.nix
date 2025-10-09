{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  validatePkgConfig,
}:

stdenv.mkDerivation rec {
  pname = "console-bridge";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "ros";
    repo = "console_bridge";
    tag = version;
    sha256 = "sha256-M3GocT0hodw3Sc2NHcFDiPVZ1XN7BqIUuYLW8OaXMqM=";
  };

  patches = [
    (fetchpatch {
      name = "console-bridge-fix-cmake-4.patch";
      url = "https://github.com/ros/console_bridge/commit/81ec67f6daf3cd19ef506e00f02efb1645597b9c.patch";
      hash = "sha256-qSYnqjD+63lWBdtrXbTawt1OpiAO9uvT7R5KmfpUmwQ=";
    })
  ];

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
