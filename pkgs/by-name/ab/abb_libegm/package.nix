{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,
  cmake,
  boost186,
  protobuf,
}:

stdenv.mkDerivation {
  pname = "abb_libegm";
  version = "0-unstable-2023-02-22";

  src = fetchFromGitHub {
    owner = "ros-industrial";
    repo = "abb_libegm";
    rev = "2c9350abfb67131cae796805fed8cd6eeb2ab7f9";
    hash = "sha256-jZ5MDYwviID55ltcnmM0XlWkvubRizHB7KCeF6JuQdg=";
  };

  buildInputs = [
    boost186
    protobuf
  ];

  nativeBuildInputs = [
    cmake
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "C++ library for interfacing with ABB robot controllers through the Externally Guided Motion (EGM) interface";
    homepage = "https://github.com/ros-industrial/abb_libegm";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ tetov ];
  };
}
