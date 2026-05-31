{
  lib,
  fetchFromGitHub,
  cmake,
  ninja,
  llvmPackages,
  nix-update-script,
}:

# redumper is using C++ modules, this requires latest C++20 compiler and build tools
llvmPackages.libcxxStdenv.mkDerivation (finalAttrs: {
  pname = "redumper";
  version = "709";

  src = fetchFromGitHub {
    owner = "superg";
    repo = "redumper";
    tag = "b${finalAttrs.version}";
    hash = "sha256-3J+/v8Rhu5yT+MgAxcNBiHLAPAcNWc/YJXxFMgOZnPs=";
  };

  patches = [
    ./darwin-fixes.patch
  ];

  __structuredAttrs = true;

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
    llvmPackages.clang-tools
  ];

  # https://github.com/superg/redumper/blob/main/.github/workflows/cmake.yml
  cmakeFlags = [
    "-DREDUMPER_VERSION_BUILD=${finalAttrs.version}"
  ];

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
