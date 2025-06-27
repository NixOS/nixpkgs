{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "px4-gpsdrivers";
  version = "0-unstable-2026-10-20";

  strictDeps = true;
  __structuredAttrs = true;
  separateDebugInfo = true;

  src = fetchFromGitHub {
    owner = "PX4";
    repo = "PX4-GPSDrivers";
    rev = "496f7d686f5d4c221ac39a5ce26230d667ffdad9";
    hash = "sha256-Hwc6n/PpidaIt1sQ5rhzp4wgnB//f4lEoP5J0JXjtUI=";
  };

  # Adds a real CMake build (upstream is only consumable by vendoring its
  # sources directly into a consumer's own build, see gps-parser-test in the
  # original CMakeLists.txt) and a portable default `definitions.h`/struct
  # trio (mirroring PX4-Autopilot's msg/{SensorGps,SatelliteInfo,SensorGnssRelative}.msg)
  # so this can be a standalone, linkable library. TODO: Upstream.
  patches = [
    ./build-overhaul.patch
  ];

  nativeBuildInputs = [ cmake ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Platform independent GPS drivers";
    homepage = "https://github.com/PX4/PX4-GPSDrivers";
    platforms = lib.platforms.all;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
})
