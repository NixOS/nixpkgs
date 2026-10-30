{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "microcdr";
  version = "2.0.1";

  strictDeps = true;
  __structuredAttrs = true;
  separateDebugInfo = true;

  src = fetchFromGitHub {
    owner = "eProsima";
    repo = "Micro-CDR";
    tag = "v${finalAttrs.version}";
    hash = "sha256-X5kE8dMpwXL2hzpT6vY+BHa70Fw21z++vs8nVARpxNk=";
  };

  # UCDR_SUPERBUILD defaults on and would otherwise just return() early and
  # delegate to cmake/SuperBuild.cmake, which only re-invokes this same
  # CMakeLists.txt (with UCDR_SUPERBUILD off) in a nested ExternalProject_Add
  # - skip straight to the real build. UCDR_ISOLATED_INSTALL defaults on and
  # installs under $out/microcdr-${version} instead of the standard FHS
  # layout find_package() consumers (such as micro-xrce-dds-client) expect
  # on CMAKE_PREFIX_PATH.
  cmakeFlags = [
    (lib.cmakeBool "UCDR_SUPERBUILD" false)
    (lib.cmakeBool "UCDR_ISOLATED_INSTALL" false)
  ];

  nativeBuildInputs = [ cmake ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Portable C library for CDR serialization aimed at embedded and constrained devices";
    homepage = "https://github.com/eProsima/Micro-CDR";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
})
