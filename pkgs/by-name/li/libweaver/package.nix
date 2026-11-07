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
  version = "0-unstable-2026-08-21";

  src = fetchFromGitHub {
    owner = "isledecomp";
    repo = "SIEdit";
    rev = "52083bec8e9f413d005a272ae1bdba00641f33b7";
    hash = "sha256-GHlJFHQ1WZFvSf8sr5jLiXRUeBrQQS2rsxsRLVSl3qo=";
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
