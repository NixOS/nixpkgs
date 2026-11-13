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

llvmPackages.stdenv.mkDerivation (finalAttrs: {
  pname = "redumper";
  version = "772";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "superg";
    repo = "redumper";
    tag = "b${finalAttrs.version}";
    hash = "sha256-CTxJ/ANhxDQeCMys/xTzv3VvW+Y7D72LLXEdMvEQojU=";
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
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "redumper";
  };
})
