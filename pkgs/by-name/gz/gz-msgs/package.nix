{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  cmake,
  python3,
  gz-cmake,
  gz-math,
  gz-tools,
  gz-utils,
  protobuf,
  tinyxml-2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gz-msgs";
  version = "11.0.0";

  src = fetchFromGitHub {
    owner = "gazebosim";
    repo = "gz-msgs";
    rev = "gz-msgs${lib.head (lib.splitString "." finalAttrs.version)}_${finalAttrs.version}";
    hash = "sha256-EGf8LJHq1YICUC5kvutJDyFIK7QnpiTjB8fxaOAOHyQ=";
  };

  nativeBuildInputs = [
    cmake
    python3
  ];

  buildInputs = [
    gz-cmake
    gz-math
    gz-tools
    gz-utils
    protobuf
    tinyxml-2
  ];

  strictDeps = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Messages for Gazebo robot simulation";
    homepage = "https://github.com/gazebosim/gz-msgs";
    changelog = "https://github.com/gazebosim/gz-msgs/blob/${finalAttrs.src.rev}/Changelog.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ShamrockLee ];
    mainProgram = "gz-msgs";
    platforms = lib.platforms.all;
  };
})
