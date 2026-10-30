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
  version = "0-unstable-2026-10-30";

  strictDeps = true;
  __structuredAttrs = true;
  separateDebugInfo = true;

  # PX4's fork of eProsima's Micro XRCE-DDS Client. PX4-Autopilot pins this
  # exact commit as a git submodule at
  # src/modules/uxrce_dds_client/Micro-XRCE-DDS-Client.
  src = fetchFromGitHub {
    owner = "PX4";
    repo = "Micro-XRCE-DDS-Client";
    rev = "711aef423edd1820347b866d1e4164832df35d04";
    hash = "sha256-ZnmhneL9Kgg+Tt6nBGveuBpowPYoTco6Leav/XxsEPY=";
  };

  # UCLIENT_SUPERBUILD defaults on and would otherwise just return() early
  # and delegate to cmake/SuperBuild.cmake, which vendors+rebuilds microcdr
  # itself via an ExternalProject_Add(... GIT_REPOSITORY ...) that fetches
  # over the network at build time (not configure time) - incompatible with
  # the sandboxed nix build. Skip straight to the real build and use our own
  # microcdr package instead. UCLIENT_ISOLATED_INSTALL defaults off already
  # (unlike microcdr's UCDR_ISOLATED_INSTALL) but is set explicitly here for
  # clarity. The UCLIENT_PIC/UCLIENT_PROFILE_* flags mirror exactly what
  # PX4-Autopilot's src/modules/uxrce_dds_client/CMakeLists.txt passes to its
  # own (now-replaced) ExternalProject_Add of this library.
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

  # PX4's fork replaces upstream's plain POSIX clock_gettime() in time.c with
  # PX4-Autopilot's own hrt_absolute_time(), declared in PX4-Autopilot's own
  # (unvendored, not part of this repo) <drivers/drv_hrt.h>. That coupling
  # only works when this submodule is compiled from inside a PX4-Autopilot
  # checkout (which forwards its own include dirs into this project's build)
  # - restore the plain POSIX time source so this library can stand on its
  # own as an independent, linkable package. TODO: Upstream to PX4's fork,
  # or gate it behind a PX4-Autopilot-provided define instead of
  # UCLIENT_PLATFORM_POSIX so out-of-tree consumers aren't affected.
  patches = [ ./posix-use-clock_gettime.patch ];

  # microxrcedds_clientConfig.cmake transitively find_package()s microcdr,
  # so anything that find_package(microxrcedds_client)s this package also
  # needs microcdr on its own CMAKE_PREFIX_PATH - propagate it rather than
  # keeping it a plain (non-propagated) buildInput.
  propagatedBuildInputs = [ microcdr ];

  nativeBuildInputs = [ cmake ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "eProsima Micro XRCE-DDS Client (PX4 fork), bridging uORB topics to DDS/ROS 2 for PX4-Autopilot's uxrce_dds_client module";
    homepage = "https://github.com/PX4/Micro-XRCE-DDS-Client";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
})
