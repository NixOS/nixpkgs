{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gz-cmake,
  spdlog,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gz-utils";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "gazebosim";
    repo = "gz-utils";
    tag = "gz-utils${lib.versions.major finalAttrs.version}_${finalAttrs.version}";
    hash = "sha256-fYzysdB608jfMb/EbqiGD4hXmPxcaVTUrt9Wx0dBlto=";
  };

  nativeBuildInputs = [
    cmake
    gz-cmake
    spdlog
  ];

  meta = {
    description = "General purpose utility classes and functions for the Gazebo libraries";
    homepage = "https://gazebosim.org/home";
    changelog = "https://github.com/gazebosim/gz-utils/blob/${finalAttrs.src.tag}/Changelog.md";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    maintainers = with lib.maintainers; [ guelakais ];
  };
})
