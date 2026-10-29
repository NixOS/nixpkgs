{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libevents";
  version = "0-unstable-2026-09-27";

  strictDeps = true;
  __structuredAttrs = true;
  separateDebugInfo = true;

  src = fetchFromGitHub {
    owner = "mavlink";
    repo = "libevents";
    rev = "0ef305faa4cffdb09f01ca862ebfc108b7ff0cd5";
    hash = "sha256-DcuY5Z3ZgsA+Je6NHVqOKaanP6FdYdetfG8qHKtZ/GM=";
  };

  sourceRoot = "${finalAttrs.src.name}/libs/cpp";

  # Upstream installs common/, parse/ and protocol/ but not generated/, even
  # though that header is part of the library's public API (consumers are
  # expected to vendor the checkout directly). TODO: Upstream.
  patches = [ ./install-generated-header.patch ];

  cmakeFlags = [ (lib.cmakeBool "ENABLE_TESTING" false) ];

  nativeBuildInputs = [ cmake ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "C++ library for the MAVLink events protocol (health/arming checks, event parsing)";
    homepage = "https://github.com/mavlink/libevents";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
})
