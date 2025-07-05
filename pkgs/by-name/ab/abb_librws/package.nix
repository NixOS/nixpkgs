{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,
  cmake,
  poco,
}:

stdenv.mkDerivation {
  pname = "abb_librws";
  version = "0-unstable-2023-02-22";

  src = fetchFromGitHub {
    owner = "ros-industrial";
    repo = "abb_librws";
    rev = "9ba08371482f3975f364011db9b1368fa0fc6b32";
    hash = "sha256-+VSc5sjh7pGqsIpFJt3AWcO7z3KEZ4dPflHsmZ1R4CU=";
  };

  nativeBuildInputs = [
    cmake
  ];

  propagatedBuildInputs = [
    poco
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "C++ library for interfacing with ABB robot controllers through the Robot Web Services (RWS) interface";
    homepage = "https://github.com/ros-industrial/abb_librws";
    license = licenses.bsd3;
    maintainers = with lib.maintainers; [
      tetov
    ];
  };
}
