{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  # By default, jemalloc puts a je_ prefix onto all its symbols on OSX, which
  # then stops downstream builds (mariadb in particular) from detecting it. This
  # option should remove the prefix and give us a working jemalloc.
  # Causes segfaults with some software (ex. rustc), but defaults to true for backward
  # compatibility.
  stripPrefix ? stdenv.hostPlatform.isDarwin,
  disableInitExecTls ? false,
  # Page size in KiB to configure jemalloc for.
  # Defaults to 64 on architectures where 64KB pages are common, 4 otherwise.
  # Note that a higher value is compatible with lower page sizes but may waste memory.
  pageSizeKiB ?
    if
      (
        stdenv.hostPlatform.isAarch64 || stdenv.hostPlatform.isLoongArch64 || stdenv.hostPlatform.isPower64
      )
    then
      64
    else
      4,
}:

let
  pageSizeMap = {
    "4" = 12;
    "16" = 14;
    "64" = 16;
  };
in
assert lib.asserts.assertOneOf "pageSizeKiB" (toString pageSizeKiB) (
  builtins.attrNames pageSizeMap
);

stdenv.mkDerivation (finalAttrs: {
  pname = "jemalloc";
  version = "5.3.1";

  src = fetchFromGitHub {
    owner = "jemalloc";
    repo = "jemalloc";
    tag = finalAttrs.version;
    hash = "sha256-krm4ACTTYg8AltmxItWwECZuMGmpXQ7VVM3f4OqMMxc=";
  };

  patches = [
    # -O3 appears to introduce an unreproducibility where
    # `rtree_read.constprop.0` shows up in some builds but
    # not others, so we fall back to O2:
    ./o3-to-o2.patch
  ];

  nativeBuildInputs = [
    autoreconfHook
  ];

  configureFlags = [
    "--with-version=${finalAttrs.version}-0-g0000000000000000000000000000000000000000"
    "--with-lg-vaddr=${with stdenv.hostPlatform; toString (if isILP32 then 32 else parsed.cpu.bits)}"
  ]
  # see the comment on stripPrefix
  ++ lib.optional stripPrefix "--with-jemalloc-prefix="
  ++ lib.optional disableInitExecTls "--disable-initial-exec-tls"
  # The upstream default is dependent on the builders' page size
  # https://github.com/jemalloc/jemalloc/issues/467
  # https://sources.debian.org/src/jemalloc/5.3.0-3/debian/rules/
  ++ [
    "--with-lg-page=${toString pageSizeMap."${toString pageSizeKiB}"}"
  ]
  # See https://github.com/jemalloc/jemalloc/issues/1997
  # Using a value of 48 should work on both emulated and native x86_64-darwin.
  ++ lib.optional (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) "--with-lg-vaddr=48";

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-Wno-error=array-bounds";

  # Tries to link test binaries binaries dynamically and fails
  doCheck = !stdenv.hostPlatform.isStatic;

  doInstallCheck = true;
  installCheckPhase = ''
    ! grep missing_version_try_git_fetch_tags $out/include/jemalloc/jemalloc.h
  '';

  # Parallel builds break reproducibility.
  enableParallelBuilding = false;

  meta = {
    homepage = "https://jemalloc.net/";
    downloadPage = "https://github.com/jemalloc/jemalloc";
    description = "General purpose malloc(3) implementation";
    longDescription = ''
      malloc(3)-compatible memory allocator that emphasizes fragmentation
      avoidance and scalable concurrency support.
    '';
    license = lib.licenses.bsd2;
    platforms = lib.platforms.all;
  };
})
