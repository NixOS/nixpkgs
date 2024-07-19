{
  lib,
  callPackage,
  fetchurl,
  linuxHeaders,
  stdenv,
  # Boolean flags
  hasLinuxHeaders ? true,
  useBSDCompatHeaders ? true,
}:
let
  sources = callPackage ./sources.nix { };
  arch =
    if stdenv.hostPlatform.isx86_64 then
      "x86_64"
    else if stdenv.hostPlatform.isx86_32 then
      "i386"
    else null;
in
stdenv.mkDerivation (finalAttrs: {
  inherit (sources.musl) pname version src;

  patches = [
    # Minor touchup to build system making dynamic linker symlink relative
    (fetchurl {
      url = "https://raw.githubusercontent.com/openwrt/openwrt/87606e25afac6776d1bbc67ed284434ec5a832b4/toolchain/musl/patches/300-relative.patch";
      hash = "sha256-VmCd+2+b1dvRTmMKAmF+OjGsHvPEL7OgqRqYxXxuykE=";
    })

    # fix parsing lines with optional fields in fstab etc.
    # NOTE: Remove for the next release since it has been merged upstream
    (fetchurl {
      url = "https://git.musl-libc.org/cgit/musl/patch/?id=751bee0ee727e8d8b003c87cff77ac76f1dbecd6";
      sha256 = "sha256-qCw132TCSaZrkISmtDb8Q8ufyt8sAJdwACkvfwuoi/0=";
    })
  ];

  env = {
    NIX_DONT_SET_RPATH = true;
    CFLAGS = toString ([
      "-fstack-protector-strong"
    ] ++ lib.optionals stdenv.hostPlatform.isPower [
      "-mlong-double-64"
    ]);
  };

  configureFlags = [
    (lib.enableFeature true "shared")
    (lib.enableFeature true "static")
    (lib.enableFeature true "debug")
    (lib.enableFeatureAs true "wrapper" "all")
    "--syslibdir=${placeholder "out"}/lib"
  ];

  outputs = [
    "out"
    "bin"
    "dev"
  ];

  outputLib = "out";

  # Disable auto-adding stack protector flags, so musl can selectively disable
  # as needed
  hardeningDisable = [ "stackprotector" ];

  strictDeps = true;

  enableParallelBuilding = true;

  dontDisableStatic = true;

  dontAddStaticConfigureFlags = true;

  separateDebugInfo = true;

  # Let's be friendlier to debuggers/perf tools
  # Neither force them on, nor force them off
  postPatch = ''
    substituteInPlace configure \
      --replace-fail -fno-unwind-tables "" \
      --replace-fail -fno-asynchronous-unwind-tables ""
  '';

  # the `-x c` flag is required here because the file extension confuses gcc,
  # that will regard the file as a linker script.
  preBuild = lib.optionalString (stdenv.targetPlatform.libc == "musl" && stdenv.targetPlatform.isx86_32) ''
    $CC -x c -c ${sources.stack_chk_fail_local_c.src} -o __stack_chk_fail_local.o
    $AR r libssp_nonshared.a __stack_chk_fail_local.o"
  '';

  postInstall = lib.concatStringsSep "\n" [
    # Not sure why, but link in all but scsi directory as that's what
    # uclibc/glibc do. Apparently glibc provides scsi itself?
    (lib.optionalString hasLinuxHeaders
      ''
        pushd ''${!outputDev}/include
        ln -s $(ls -d ${linuxHeaders}/include/* | grep -v "scsi$") .
        popd
      '')

    (lib.optionalString (stdenv.targetPlatform.libc == "musl" && stdenv.targetPlatform.isx86_32)
      ''install -D libssp_nonshared.a ''${!outputLib}/lib/libssp_nonshared.a'')

    # Create 'ldd' symlink, builtin
    ''ln -s ''${!outputLib}/lib/libc.so ''${!outputBin}/bin/ldd''

    # (impure) cc wrapper around musl for interactive usuage
    ''
      for i in musl-gcc musl-clang ld.musl-clang; do
        moveToOutput bin/$i ''${!outputDev}
      done
      moveToOutput lib/musl-gcc.specs ''${!outputDev}
      substituteInPlace ''${!outputDev}/bin/musl-gcc \
        --replace-fail ''${!outputLib}/lib/musl-gcc.specs ''${!outputDev}/lib/musl-gcc.specs
    ''

    # provide 'iconv' utility, using just-built headers, libc/ldso
    ''
      $CC ${sources.iconv_c.src} -o ''${!outputBin}/bin/iconv \
        -I''${!outputDev}/include \
        -L''${!outputLib}/lib -Wl,-rpath=''${!outputLib}/lib \
        -lc \
        -B ''${!outputLib}/lib \
        -Wl,-dynamic-linker=$(ls ''${!outputLib}/lib/ld-*)
    ''
    # Create 'libc.musl-$arch' symlink
    (lib.optionalString (arch != null)
      ''ln -rs ''${!outputLib}/lib/libc.so ''${!outputLib}/lib/libc.musl-${arch}.so.1'')
    (lib.optionalString useBSDCompatHeaders
      ''
        install -D ${sources.musl-compat.src}/src/{cdefs,queue,tree}.h ''${!outputDev}/include/sys/
      '')
  ];

  passthru = {
    inherit hasLinuxHeaders linuxHeaders;
  };

  meta = {
    homepage = "https://musl.libc.org/";
    description = "Efficient, small libc implementation";
    longDescription = ''
      musl, pronounced /mŭs′əl/ (like the word "mussel" or "muscle"), is a
      "libc", an implementation of the standard library functionality described
      in the ISO C and POSIX standards, plus common extensions, built on top of
      the Linux system calls API. While the kernel governs access to hardware,
      memory, filesystems, and the privileges for accessing these resources,
      libc is responsible for:

      - providing C bindings for the OS interfaces;
      - constructing higher-level buffered stdio, memory allocation management,
        thread creation and synchronization operations, shared library loading,
        and so on using the lower-level interfaces the kernel provides;
      - implementing the pure library routines of the C language like strstr,
        snprintf, strtol, exp, sqrt, etc.

      musl has history and development roots going back to 2005, but was named
      and first released as musl in 2011, as an alternative to glibc and uClibc
      with an ambitious goal to meet the needs of both tiny embedded systems and
      typical desktops and servers.
    '';
    changelog = "https://git.musl-libc.org/cgit/musl/tree/WHATSNEW?h=v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      AndersonTorres
      thoughtpolice
    ];
    platforms = [
      "aarch64-linux"
      "armv5tel-linux"
      "armv6l-linux"
      "armv7a-linux"
      "armv7l-linux"
      "i686-linux"
      "m68k-linux"
      "microblaze-linux"
      "microblazeel-linux"
      "mips-linux"
      "mips64-linux"
      "mips64el-linux"
      "mipsel-linux"
      "powerpc64-linux"
      "powerpc64le-linux"
      "riscv64-linux"
      "s390x-linux"
      "x86_64-linux"
    ];
  };
})
