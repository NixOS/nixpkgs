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
  version = "0-unstable-2026-07-25";

  src = fetchFromGitHub {
    owner = "isledecomp";
    repo = "SIEdit";
    rev = "abb6d47139d7a03c5c1bad9b89e2267849e27904";
    hash = "sha256-T+w8aR/W19bVsK+cFWZpbB4uhPcE27Yz2yMbhzzMNnA=";
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
