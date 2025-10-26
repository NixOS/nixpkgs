{
  lib,
  stdenv,

  fetchFromGitHub,
  fetchpatch,
  nix-update-script,

  cmake,

  withShared ? (!stdenv.hostPlatform.isStatic),
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qpoases";
  version = "3.2.2";

  src = fetchFromGitHub {
    owner = "coin-or";
    repo = "qpOASES";
    tag = "releases/${finalAttrs.version}";
    hash = "sha256-L6uBRXaPJZinIRTm+x+wnXmlVkSlWm4XMB5yX/wxg2A=";
  };

  patches = [
    (fetchpatch {
      name = "qpoases-fix-cmake-4.patch";
      url = "https://github.com/coin-or/qpOASES/commit/35b762ba3fee2e009d9e99650c68514da05585c5.patch";
      hash = "sha256-I6l+ah1j45VEMokZqX6DYVmE55uWlVi0rx2B+HQv5Ik=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" withShared)
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "releases/(.*)"
    ];
  };

  meta = with lib; {
    description = "Open-source C++ implementation of the recently proposed online active set strategy";
    homepage = "https://github.com/coin-or/qpOASES";
    changelog = "https://github.com/coin-or/qpOASES/blob/${finalAttrs.src.tag}/VERSIONS.txt";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ nim65s ];
  };
})
