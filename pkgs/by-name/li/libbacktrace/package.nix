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
  version = "0-unstable-2026-05-03";

  src = fetchFromGitHub {
    owner = "ianlancetaylor";
    repo = "libbacktrace";
    rev = "96664e69b1ecdb76e824be1d9e8f475b76dd08cf";
    hash = "sha256-+tV6W8SnFWKweAASvFfb+i6bz73ssVGikNhVpq3YbT4=";
  };

  patches = [
    # Support multiple debug dirs.
    # https://github.com/ianlancetaylor/libbacktrace/pull/100
    ./0002-libbacktrace-Allow-configuring-debug-dir.patch
    ./0003-libbacktrace-Support-multiple-build-id-directories.patch

    # Support NIX_DEBUG_INFO_DIRS environment variable.
    ./0004-libbacktrace-Support-NIX_DEBUG_INFO_DIRS-environment.patch
  ];

  # https://github.com/ianlancetaylor/libbacktrace/issues/163
  postPatch =
    lib.optionalString
      (stdenv.hostPlatform.isPower64 && stdenv.hostPlatform.isBigEndian && stdenv.hostPlatform.isAbiElfv1)
      ''
        substituteInPlace Makefile.am \
          --replace-fail 'MAKETESTS += mtest_minidebug' '# MAKETESTS += mtest_minidebug'
      '';

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
