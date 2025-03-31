{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  cmake,
  gz-cmake,
  gz-common,
  gz-fuel-tools,
  # gz-gui,
  gz-math,
  gz-msgs,
  # gz-physics,
  # gz-plugin,
  # gz-rendoring,
  # gz-sensors,
  gz-tools,
  # gz-transport,
  gz-utils,
  protobuf,
# sdformat,
}:

stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  pname = "gz-sim";
  version = "9.0.0";

  src = fetchFromGitHub {
    owner = "gazebosim";
    repo = "gz-sim";
    rev = "gz-sim${lib.head (lib.splitString "." finalAttrs.version)}_${finalAttrs.version}";
    hash = "sha256-gsWKknqcTiJc4YHIkmg1YGItwHG1As2OUnpPBQIwqj8=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    gz-cmake
    gz-common
    gz-fuel-tools
    # gz-gui,
    gz-math
    gz-msgs
    # gz-physics
    # gz-plugin
    # gz-rendering
    # gz-sensors
    gz-tools
    # gz-transport
    gz-utils
    protobuf
    # sdformat
  ];

  strictDeps = true;

  cmakeDefinitions = {
    SKIP_PYBIND11 = true;
  };

  cmakeFlags =
    # TODO(@ShamrockLee):
    # Remove after a unified way to specify CMake definitions becomes available.
    lib.mapAttrsToList (
      n: v:
      let
        specifiedType = finalAttrs.cmakeDefinitionTypes.${n} or "";
        type =
          if specifiedType != "" then
            specifiedType
          else if lib.isBool v then
            "bool"
          else
            "string";
      in
      if lib.toUpper type == "BOOL" then lib.cmakeBool n v else lib.cmakeOptionType type n v
    ) finalAttrs.cmakeDefinitions;

  doCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Gazebo, the open source robotics simulator";
    homepage = "https://github.com/gazebosim/gz-sim";
    changelog = "https://github.com/gazebosim/gz-sim/blob/${finalAttrs.src.rev}/Changelog.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ShamrockLee ];
    mainProgram = "gz-sim";
    platforms = lib.platforms.all;
  };
})
