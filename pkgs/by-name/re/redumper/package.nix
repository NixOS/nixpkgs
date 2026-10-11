{
  lib,
  fetchFromGitHub,
  cmake,
  ctestCheckHook,
  gtest,
  llvmPackages,
  ninja,
  nix-update-script,
  versionCheckHook,
}:

# redumper is using C++ modules, this requires latest C++20 compiler and build tools
llvmPackages.libcxxStdenv.mkDerivation (finalAttrs: {
  pname = "redumper";
  version = "767";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "superg";
    repo = "redumper";
    tag = "b${finalAttrs.version}";
    hash = "sha256-5mdBDs/DfSbbNfTFBZ1LuFC40bhsEdXLU1FOIsBrPvs=";
  };

  patches = [
    ./remove-macos-bundling.patch
  ];

  nativeBuildInputs = [
    cmake
    ninja
    llvmPackages.clang-tools
  ];

  # https://github.com/superg/redumper/blob/main/.github/workflows/cmake.yml
  cmakeFlags = [
    (lib.cmakeFeature "REDUMPER_VERSION_BUILD" finalAttrs.src.tag)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_GOOGLETEST" "${gtest.src}")
    # upstream links statically on Linux by default
    (lib.cmakeFeature "REDUMPER_LINKER_FLAGS" "")
  ];

  doCheck = true;
  nativeCheckInputs = [ ctestCheckHook ];
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "b(\\d+)"
    ];
  };

  meta = {
    description = "Low level CD dumper utility";
    homepage = "https://github.com/superg/redumper";
    changelog = "https://github.com/superg/redumper/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      hughobrien
      keenanweaver
    ];
    platforms = lib.platforms.unix;
    mainProgram = "redumper";
  };
})
