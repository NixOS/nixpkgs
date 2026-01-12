{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "nsync";
  version = "1.29.2";

  src = fetchFromGitHub {
    owner = "google";
    repo = "nsync";
    rev = version;
    hash = "sha256-RAwrS8Vz5fZwZRvF4OQfn8Ls11S8OIV2TmJpNrBE4MI=";
  };

  postPatch = ''
    # CMake 3.0 is deprecated and is no longer supported by CMake > 4
    # inline of https://github.com/google/nsync/pull/27
    substituteInPlace CMakeLists.txt \
     --replace-fail "cmake_minimum_required (VERSION 2.8.12)" \
       "cmake_minimum_required (VERSION 3.10)"
  '';

  nativeBuildInputs = [ cmake ];

  # Needed for case-insensitive filesystems like on macOS
  # because a file named BUILD exists already.
  cmakeBuildDir = "build_dir";

  meta = {
    homepage = "https://github.com/google/nsync";
    description = "C library that exports various synchronization primitives";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      puffnfresh
      Luflosi
    ];
    platforms = lib.platforms.unix;
  };
}
