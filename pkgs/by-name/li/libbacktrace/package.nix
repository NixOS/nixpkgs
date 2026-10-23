{
  stdenvNoCC,
  stdenv,
  overrideCC,
  buildPackages,
  lib,
  fetchFromGitHub,
  enableStatic ? stdenv.hostPlatform.isStatic,
  enableShared ? !stdenv.hostPlatform.isStatic,
  unstableGitUpdater,
  autoreconfHook,
}:

let
  # With GCC NG, `libstdc++` links this rather than compiling its own copy,
  # which puts it below the C++ standard library rather than above; built with
  # the ordinary `stdenv` the two would create a cycle.
  #
  # I would rather this bootstrapping detail not leak into the `package.nix`,
  # but I don't see another solution available since all-package.nix overrides
  # of "by-name" packages are no longer allowed.
  #
  # TODO: hoist this back out to a `stdenvNoCXX` in `all-packages.nix`,
  # where the next package needing a hosted-but-C++-free compiler can
  # share it. `nixpkgs-vet` blocks that today: it wants `strictDeps` and
  # `__structuredAttrs`, but this is only relevant for derivations made
  # with `stdenv.mkDerivation` --- `stdenv` itself is *not* such a
  # derivation!
  stdenv' =
    if stdenvNoCC.hostPlatform.useLLVM or false then
      overrideCC stdenvNoCC buildPackages.llvmPackages.clangNoLibcxx
    else if stdenvNoCC.hostPlatform.useGccNG or false then
      overrideCC stdenvNoCC buildPackages.gccNGPackages.gccWithLibatomic
    else
      stdenv;
in
let
  stdenv = stdenv';
in

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

  # A (PE/COFF) DLL has to resolve every symbol at link time, and
  # libtool declines to build one at all unless told unresolved symbols
  # are not allowed. We don't have any unresolved symbols so we can pass
  # this flag.
  #
  # We only want this affecting the build. It could mess up configure
  # scripts if we defined it for the entire derivation.
  #
  # TODO use `lib.optionalString` at the cost of some rebuilds.
  makeFlags = if enableShared && stdenv.hostPlatform.isPE then "LDFLAGS=-no-undefined" else null;

  doCheck = stdenv.hostPlatform.isLinux && !stdenv.hostPlatform.isMusl;

  passthru = {
    updateScript = unstableGitUpdater { };
  };

  meta = {
    description = "C library that may be linked into a C/C++ program to produce symbolic backtraces";
    homepage = "https://github.com/ianlancetaylor/libbacktrace";
    maintainers = with lib.maintainers; [ twey ];
    license = lib.licenses.bsd3;
  };
}
