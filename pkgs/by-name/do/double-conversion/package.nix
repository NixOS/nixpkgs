{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  ninja,
  ctestCheckHook,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "double-conversion";
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = "double-conversion";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-M80H+azCzQYa4/gBLWv5GNNhEuHsH7LbJ/ajwmACnrM=";
  };

  patches = [
    # Fix the build with CMake 4.
    (fetchpatch {
      name = "double-conversion-fix-cmake-4-1.patch";
      url = "https://github.com/google/double-conversion/commit/101e1ba89dc41ceb75090831da97c43a76cd2906.patch";
      hash = "sha256-VRmuNXdzt/I+gWbz5mwWkx5IGn8Vsl9WkdwRsuwZdkU=";
    })
    (fetchpatch {
      name = "double-conversion-fix-cmake-4-2.patch";
      url = "https://github.com/google/double-conversion/commit/0604b4c18815aadcf7f4b78dfa6bfcb91a634ed7.patch";
      hash = "sha256-cJBp1ou1O/bMQ/7kvcX52dWbUdhmPfQ9aWmEhQdyhis=";
    })
    (fetchpatch {
      name = "double-conversion-add-pkg-config.patch";
      url = "https://github.com/google/double-conversion/commit/ddfd18c58ecc32fc74afc1083bb8774240b54efb.patch";
      hash = "sha256-/pKCL19vS8fNwCm27yTNP+32ApHTH5dEGpnsMI11Lf4=";
    })
  ];

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    ninja
    ctestCheckHook
  ];

  doCheck = true;

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTING" true)
    (lib.cmakeBool "BUILD_SHARED_LIBS" stdenv.hostPlatform.hasSharedLibraries)
  ];

  # Case sensitivity issue
  preConfigure = lib.optionalString stdenv.hostPlatform.isDarwin ''
    rm BUILD
  '';

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = with lib; {
    pkgConfigModules = [ "double-conversion" ];
    description = "Binary-decimal and decimal-binary routines for IEEE doubles";
    homepage = "https://github.com/google/double-conversion";
    license = licenses.bsd3;
    platforms = platforms.unix ++ platforms.windows;
    maintainers = with lib.maintainers; [ fzakaria ];
  };
})
