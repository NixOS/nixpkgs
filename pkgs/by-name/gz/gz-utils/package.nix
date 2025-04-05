{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  cmake,
  gz-cmake,
  spdlog,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gz-utils";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "gazebosim";
    repo = "gz-utils";
    rev = "gz-utils${lib.head (lib.splitString "." finalAttrs.version)}_${finalAttrs.version}";
    hash = "sha256-maq0iGCGbrjVGwBNNIYYSAKXxszwlAJS4FLrGNxsA5c=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    gz-cmake
    spdlog
  ];

  strictDeps = true;

  doCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Gazebo Utils, classes and functions for robot applications";
    homepage = "https://github.com/gazebosim/gz-utils";
    changelog = "https://github.com/gazebosim/gz-utils/blob/${finalAttrs.src.rev}/Changelog.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ShamrockLee ];
    mainProgram = "gz-utils";
    platforms = lib.platforms.all;
  };
})
