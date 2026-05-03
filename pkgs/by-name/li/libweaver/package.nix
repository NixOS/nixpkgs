{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  testers,
  unstableGitUpdater,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libweaver";
  version = "0-unstable-2026-04-24";

  src = fetchFromGitHub {
    owner = "isledecomp";
    repo = "SIEdit";
    rev = "a08fbcb9a93b9029366eabe0f23d0279fb9f15b0";
    hash = "sha256-8NTYeyEorQArzL5VFKYnRoaITK1+3S7RKy8aslxjLvk=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    ninja
  ];

  cmakeFlags = [
    (lib.cmakeBool "LIBWEAVER_BUILD_APP" false)
  ];

  passthru = {
    updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };
    tests.cmake-config = testers.hasCmakeConfigModules {
      package = finalAttrs.finalPackage;
      moduleNames = [ "libweaver" ];
    };
  };

  meta = {
    description = "library for interacting with SI files";
    homepage = "https://github.com/isledecomp/SIEdit/tree/master/include/libweaver";
    license = lib.licenses.gpl3Only;
    maintainers = [
      lib.maintainers.RossSmyth
    ];
  };
})
