{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
}:

# Header-only, pre-generated (by mavlink/mavlink) C MAVLink headers for all
# dialects. Upstream ships no build system; the CMake interface library here
# is ours, exposing the same four include directories consumers of this repo
# have always used directly (root, all/, common/, development/).
#
# Upstream's own C-generator (mavgen) also generates a pack/unpack round-trip
# self-test (testsuite.h, built on a MAVLINK_ASSERT macro) into every
# dialect, right alongside its message headers - but c_library_v2 vendors
# only the generated headers, not the generator's own test driver or a real
# MAVLINK_ASSERT (protocol.h's shipped default is a no-op). cmake-build.patch
# supplies both, so these round-trip checks actually run, one dialect at a
# time, against the headers this derivation packages (the "all" meta-dialect
# is skipped: its testsuite.h has an upstream mavgen bug - see the patch -
# and every message it contains is already covered via its 18 constituent
# dialects).
stdenv.mkDerivation (finalAttrs: {
  pname = "mavlink-c-library-v2";
  version = "0-unstable-2026-10-28";

  strictDeps = true;
  __structuredAttrs = true;
  separateDebugInfo = true;

  src = fetchFromGitHub {
    owner = "mavlink";
    repo = "c_library_v2";
    rev = "a2d0ecf011a4aaa7840480e43f4e38d8c9e79d29";
    hash = "sha256-VYNrnSWkV6xlcp1Bykv5MFexBTIzEAgwgMXAfzZAnro=";
  };

  patches = [
    ./cmake-build.patch
  ];

  doCheck = true;

  nativeBuildInputs = [ cmake ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Pre-generated C MAVLink headers for all dialects (common, development, and vendor-specific)";
    homepage = "https://github.com/mavlink/c_library_v2";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
})
