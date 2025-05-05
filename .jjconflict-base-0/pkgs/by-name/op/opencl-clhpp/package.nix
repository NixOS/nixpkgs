{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3,
  ruby,
  opencl-headers,
  khronos-ocl-icd-loader,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opencl-clhpp";
  version = "2024.10.24";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenCL-CLHPP";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    sha256 = "sha256-3RVZJIt03pRmjrPa9q6h6uqFCuTnxvEqjUGUmdwybbY=";
  };

  nativeBuildInputs = [
    cmake
    python3
  ];

  propagatedBuildInputs = [ opencl-headers ];

  strictDeps = true;

  doCheck = true;
  checkInputs = [ khronos-ocl-icd-loader ];
  nativeCheckInputs = [ ruby ];

  cmakeFlags = [
    (lib.cmakeBool "OPENCL_CLHPP_BUILD_TESTING" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "BUILD_EXAMPLES" finalAttrs.finalPackage.doCheck)
  ];

  passthru.tests = {
    pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
      moduleNames = [ "OpenCL-CLHPP" ];
      # Package version does not match the pkg-config module version.
    };
  };

  meta = {
    description = "OpenCL Host API C++ bindings";
    homepage = "http://github.khronos.org/OpenCL-CLHPP/";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.xokdvium ];
    platforms = lib.platforms.unix;
  };
})
