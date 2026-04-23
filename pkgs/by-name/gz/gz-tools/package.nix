{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  cmake,
  backward-cpp,
  gz-cmake,
  ruby,
}:

stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  pname = "gz-tools";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "gazebosim";
    repo = "gz-tools";
    rev = "gz-tools${lib.head (lib.splitString "." finalAttrs.version)}_${finalAttrs.version}";
    hash = "sha256-CY+W1jWIkszKwKuLgKmJpZMXHn0RnueMHFSDhOXIzLg=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs =
    [
      gz-cmake
      ruby
    ]
    ++ lib.optionals finalAttrs.cmakeDefinitions.USE_SYSTEM_BACKWARDCPP [
      backward-cpp
    ];

  strictDeps = true;

  cmakeDefinitions = {
    # gz-tools requires the system backward-cpp
    # to provide BackwardCpp.cmake or backward-cpp.cmak,
    # which is currently not the case in Nixpkgs.
    USE_SYSTEM_BACKWARDCPP = false;
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

  passthru = {
    tests = {
      check = finalAttrs.finalPackage.overrideAttrs {
        doCheck = true;

        nativeCheckInputs = [
          ruby
        ];
      };
    };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Command line tools for the Gazebo libraries";
    homepage = "https://github.com/gazebosim/gz-tools";
    changelog = "https://github.com/gazebosim/gz-tools/blob/${finalAttrs.src.rev}/Changelog.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ShamrockLee ];
    mainProgram = "gz";
    platforms = lib.platforms.all;
  };
})
