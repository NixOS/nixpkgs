{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  microcdr,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "micro-xrce-dds-client";
  version = "3.0.2";

  strictDeps = true;
  __structuredAttrs = true;
  separateDebugInfo = true;

  # PX4-Autopilot vendors PX4/Micro-XRCE-DDS-Client as its
  # src/modules/uxrce_dds_client/Micro-XRCE-DDS-Client submodule, but that
  # fork's only real divergence from eProsima's own upstream is a 19-line
  # addition to src/c/util/time.c coupling it to PX4-Autopilot's internal
  # hrt_absolute_time() (drivers/drv_hrt.h, unavailable to a standalone
  # build) - otherwise it just lags behind eProsima's own development.
  # Nothing in px4-uorb-headers' consumption of this library depends on
  # that PX4-specific timing behavior (it's not run inside PX4-Autopilot's
  # lockstep-scheduled SITL simulation), so track eProsima's real upstream
  # directly instead of the fork - it never had this problem to begin with.
  src = fetchFromGitHub {
    owner = "eProsima";
    repo = "Micro-XRCE-DDS-Client";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vL2A2La1MdZfxO84BVVcSu31L74+PSmfk5fH5OcJtks=";
  };

  # UCLIENT_SUPERBUILD defaults on and would otherwise just return() early
  # and delegate to cmake/SuperBuild.cmake, which vendors+rebuilds microcdr
  # itself via an ExternalProject_Add(... GIT_REPOSITORY ...) that fetches
  # over the network at build time (not configure time) - incompatible with
  # the sandboxed nix build. Skip straight to the real build and use our own
  # microcdr package instead. UCLIENT_ISOLATED_INSTALL defaults off already
  # (unlike microcdr's UCDR_ISOLATED_INSTALL) but is set explicitly here for
  # clarity. The UCLIENT_PIC/UCLIENT_PROFILE_* flags mirror what
  # PX4-Autopilot's src/modules/uxrce_dds_client/CMakeLists.txt passes to its
  # own (replaced) ExternalProject_Add of PX4's fork of this library.
  cmakeFlags = [
    (lib.cmakeBool "UCLIENT_SUPERBUILD" false)
    (lib.cmakeBool "UCLIENT_ISOLATED_INSTALL" false)
    (lib.cmakeBool "UCLIENT_PIC" false)
    (lib.cmakeBool "UCLIENT_PROFILE_TCP" false)
    (lib.cmakeBool "UCLIENT_PROFILE_UDP" true)
    (lib.cmakeBool "UCLIENT_PROFILE_SERIAL" true)
    (lib.cmakeBool "UCLIENT_PROFILE_DISCOVERY" false)
    (lib.cmakeBool "UCLIENT_PROFILE_CUSTOM_TRANSPORT" false)
    (lib.cmakeBool "UCLIENT_PROFILE_MULTITHREAD" false)
    (lib.cmakeBool "UCLIENT_PROFILE_SHARED_MEMORY" false)
  ];

  # microxrcedds_clientConfig.cmake transitively find_package()s microcdr,
  # so anything that find_package(microxrcedds_client)s this package also
  # needs microcdr on its own CMAKE_PREFIX_PATH - propagate it rather than
  # keeping it a plain (non-propagated) buildInput.
  propagatedBuildInputs = [ microcdr ];

  nativeBuildInputs = [ cmake ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "eProsima Micro XRCE-DDS Client, a C API for the eXtremely Resource Constrained Environments DDS protocol (used by PX4-Autopilot's uxrce_dds_client module)";
    homepage = "https://github.com/eProsima/Micro-XRCE-DDS-Client";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
})
