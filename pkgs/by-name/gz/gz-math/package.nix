{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  cmake,
  eigen,
  gz-cmake,
  gz-utils,
}:

stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  pname = "gz-math";
  version = "8.0.0";

  src = fetchFromGitHub {
    owner = "gazebosim";
    repo = "gz-math";
    rev = "gz-math${lib.head (lib.splitString "." finalAttrs.version)}_${finalAttrs.version}";
    hash = "sha256-3+846hhsaBaiFLIURlXQx6Z1+VYfp9UZgjdl96JvrRw=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    eigen
    gz-cmake
    gz-utils
  ];

  strictDeps = true;

  cmakeDefinitions = {
    SKIP_SWIG = true;
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
    description = "General purpose math library for robot applications";
    homepage = "https://github.com/gazebosim/gz-math";
    changelog = "https://github.com/gazebosim/gz-math/blob/${finalAttrs.src.rev}/Changelog.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ShamrockLee ];
    mainProgram = "gz-math";
    platforms = lib.platforms.all;
  };
})
