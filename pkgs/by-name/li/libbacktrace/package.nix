{
  stdenv,
  lib,
  fetchFromGitHub,
  enableStatic ? stdenv.hostPlatform.isStatic,
  enableShared ? !stdenv.hostPlatform.isStatic,
  unstableGitUpdater,
  autoreconfHook,
}:

stdenv.mkDerivation {
  pname = "libbacktrace";
  version = "0-unstable-2025-11-06";

  src = fetchFromGitHub {
    owner = "ianlancetaylor";
    repo = "libbacktrace";
    rev = "b9e40069c0b47a722286b94eb5231f7f05c08713";
    hash = "sha256-vi33Bhg2LT5uWN63PHkD8CaOjTXBwZhBwFFhaezJ0e4=";
  };

  patches = [
    # Support multiple debug dirs.
    # https://github.com/ianlancetaylor/libbacktrace/pull/100
    ./0002-libbacktrace-Allow-configuring-debug-dir.patch
    ./0003-libbacktrace-Support-multiple-build-id-directories.patch

    # Support NIX_DEBUG_INFO_DIRS environment variable.
    ./0004-libbacktrace-Support-NIX_DEBUG_INFO_DIRS-environment.patch
  ];

  nativeBuildInputs = [
    autoreconfHook
  ];

  configureFlags = [
    (lib.enableFeature enableStatic "static")
    (lib.enableFeature enableShared "shared")
  ];

  doCheck = stdenv.hostPlatform.isLinux && !stdenv.hostPlatform.isMusl;

  passthru = {
    updateScript = unstableGitUpdater { };
  };

  meta = {
    description = "C library that may be linked into a C/C++ program to produce symbolic backtraces";
    homepage = "https://github.com/ianlancetaylor/libbacktrace";
    maintainers = with lib.maintainers; [ twey ];
    license = with lib.licenses; [ bsd3 ];
  };
}
