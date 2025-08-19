{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  imath,
  rapidjson,
}:

stdenv.mkDerivation rec {
  pname = "opentimelineio";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "OpenTimelineIO";
    rev = "v${version}";
    hash = "sha256-53KXjbhHxuEtu6iRGWrirvFamuZ/WbOTcKCfs1iqKmM=";
  };

  nativeBuildInputs = [
    cmake
  ];

  propagatedBuildInputs = [
    imath
  ];

  buildInputs = [
    rapidjson
  ];

  cmakeFlags = [
    "-DOTIO_DEPENDENCIES_INSTALL=0"
    "-DOTIO_FIND_IMATH=1"
  ];

  meta = {
    description = "Open Source API and interchange format for editorial timeline information";
    homepage = "https://github.com/AcademySoftwareFoundation/OpenTimelineIO";
    license = lib.licenses.asl20;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
