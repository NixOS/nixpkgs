{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
}:

stdenv.mkDerivation (final: {
  pname = "CDP8";
  version = "8.0.1-unstable-2026-01-07";

  src = fetchFromGitHub {
    owner = "ComposersDesktop";
    repo = "CDP8";
    rev = "57067a05b0f925cceb3a6c3368afb4d85a7b2842";
    hash = "sha256-7BIx9CjNXnlHk5Ffg013L9dG0GJ0pvYCXu0cf/Gv01E=";
  };

  patches = [
    # Remove mentions of incompatible -stdlib
    ./clear-stdlib-for-use-with-gcc.patch
  ];

  # Build errors in many files when format hardening is enabled:
  #   cc1: error: '-Wformat-security' ignored without '-Wformat' [-Werror=format-security]
  hardeningDisable = [ "format" ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  cmakeFlags = [
    # file RPATH_CHANGE could not write new RPATH.
    (lib.cmakeBool "CMAKE_SKIP_BUILD_RPATH" true)
  ];

  meta = {
    description = "Large suite of command line programs for sound processing";
    homepage = "http://www.composersdesktop.com/";
    license = lib.licenses.lgpl2;
    maintainers = with lib.maintainers; [ jpotier ];
    platforms = lib.platforms.linux;
  };
})
