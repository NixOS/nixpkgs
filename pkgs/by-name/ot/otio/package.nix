{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  imath,
  python3,
  rapidjson,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "otio";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "OpenTimelineIO";
    tag = "v${finalAttrs.version}";
    hash = "sha256-53KXjbhHxuEtu6iRGWrirvFamuZ/WbOTcKCfs1iqKmM=";
  };

  nativeBuildInputs = [
    cmake
    python3
  ];

  buildInputs = [
    imath
    rapidjson
  ];

  cmakeFlags = [
    (lib.cmakeBool "OTIO_PYTHON_INSTALL" false)
    (lib.cmakeBool "OTIO_DEPENDENCIES_INSTALL" false)
    (lib.cmakeBool "OTIO_FIND_IMATH" true)
    (lib.cmakeBool "OTIO_SHARED_LIBS" true)
    (lib.cmakeBool "OTIO_AUTOMATIC_SUBMODULES" false)
  ];

  meta = {
    description = "Interchange format and API for editorial cut information";
    homepage = "http://opentimeline.io/";
    changelog = "https://github.com/AcademySoftwareFoundation/OpenTimelineIO/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ liberodark ];
    platforms = lib.platforms.linux;
  };
})
