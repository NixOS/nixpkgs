{
  lib,
  fetchFromGitHub,
  cmake,
  ctestCheckHook,
  ninja,
  llvmPackages,
  gtest,
  versionCheckHook,
  nix-update-script,
}:

# redumper is using C++ modules, this requires latest C++20 compiler and build tools
llvmPackages.libcxxStdenv.mkDerivation (finalAttrs: {
  pname = "redumper";
  version = "770";

  src = fetchFromGitHub {
    owner = "superg";
    repo = "redumper";
    tag = "b${finalAttrs.version}";
    hash = "sha256-TW2Pf1w2nzgc8r/k+jT8AbmxLK0b+a9MBFV0oGi00XA=";
  };

  patches = [
    ./remove-macos-bundling.patch
  ];

  __structuredAttrs = true;

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ctestCheckHook
    ninja
    llvmPackages.clang-tools
  ];

  # https://github.com/superg/redumper/blob/main/.github/workflows/cmake.yml
  cmakeFlags = [
    (lib.cmakeFeature "REDUMPER_VERSION_BUILD" "${finalAttrs.src.tag}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_GOOGLETEST" "${gtest.src}")
    (lib.cmakeFeature "REDUMPER_LINKER_FLAGS" "")
  ];

  doCheck = true;

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "b(.*)"
    ];
  };

  meta = {
    homepage = "https://github.com/superg/redumper";
    description = "Low level CD dumper utility";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ hughobrien ];
    platforms = lib.platforms.unix;
    mainProgram = "redumper";
  };
})
