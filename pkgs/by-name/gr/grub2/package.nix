{
  lib,
  stdenv,
  fetchurl,
  fetchgit,
  flex,
  bison,
  python3,
  autoconf,
  autoconf-archive,
  automake,
  autoreconfHook,
  libtool,
  bash,
  gettext,
  ncurses,
  libusb-compat-0_1,
  freetype,
  qemu,
  lvm2,
  unifont,
  pkg-config,
  help2man,
  fetchzip,
  fetchpatch,
  buildPackages,
  nixosTests,
  fuse3, # only needed for grub-mount
  xz, # for xz compression support. Usually counterproductive, so don't try to force compression in your GRUB install.
  runtimeShell,
  zfs ? null,
  efiSupport ? false,
  ieee1275Support ? false,
  zfsSupport ? false,
  xenSupport ? false,
  xenPvhSupport ? false,
  corebootSupport ? false,
  kbdcompSupport ? corebootSupport,
  ckbcomp,
}:

let
  pcSystems = {
    i686-linux.target = "i386";
    x86_64-linux.target = "i386";
  };

  corebootSystemsBuild = {
    i686-linux.target = "i386";
    x86_64-linux.target = "i386";
  };

  efiSystemsBuild = {
    i686-linux.target = "i386";
    x86_64-linux.target = "x86_64";
    armv7l-linux.target = "arm";
    aarch64-linux.target = "aarch64";
    loongarch64-linux.target = "loongarch64";
    riscv32-linux.target = "riscv32";
    riscv64-linux.target = "riscv64";
  };

  # For aarch64, we need to use '--target=aarch64-efi' when building,
  # but '--target=arm64-efi' when installing. Insanity!
  efiSystemsInstall = {
    i686-linux.target = "i386";
    x86_64-linux.target = "x86_64";
    armv7l-linux.target = "arm";
    aarch64-linux.target = "arm64";
    loongarch64-linux.target = "loongarch64";
    riscv32-linux.target = "riscv32";
    riscv64-linux.target = "riscv64";
  };

  ieee1275SystemsBuild = {
    x86_64-linux.target = "i386";
    powerpc64-linux.target = "powerpc";
  };

  xenSystemsBuild = {
    i686-linux.target = "i386";
    x86_64-linux.target = "x86_64";
  };

  xenPvhSystemsBuild = {
    i686-linux.target = "i386";
    x86_64-linux.target = "i386"; # Xen PVH is only i386 on x86.
  };

  inPCSystems = lib.any (system: stdenv.hostPlatform.system == system) (lib.attrNames pcSystems);

  gnulib = fetchgit {
    url = "https://https.git.savannah.gnu.org/git/gnulib.git";
    # NOTE: get $GNULIB_REVISION from bootstrap.conf!
    rev = "9f48fb992a3d7e96610c4ce8be969cff2d61a01b";
    hash = "sha256-mzbF66SNqcSlI+xmjpKpNMwzi13yEWoc1Fl7p4snTto=";
  };

  # The locales are fetched from translationproject.org at build time,
  # but those translations are not versioned/stable. For that reason
  # we take them from the nearest release tarball instead:
  locales = fetchzip {
    url = "mirror://gnu/grub/grub-${version}.tar.gz";
    hash = "sha256-NUlE6l8Ul3i1Si9mZgND6lnvFqc74EGptHV2iCtu+As=";
  };

  # This is the variable that sets the GRUB release.
  version = "2.16";
in

assert zfsSupport -> zfs != null;
assert lib.asserts.assertMsg (
  lib.lists.length (
    lib.lists.filter (x: x) [
      efiSupport
      ieee1275Support
      xenSupport
      xenPvhSupport
      corebootSupport
    ]
  ) <= 1 # (0 == pc)
) "Only <= 1 of grub2's platform-related *Support options may be enabled at the same time";

stdenv.mkDerivation rec {
  pname = "grub";
  inherit version;

  src = fetchgit {
    url = "https://gitlab.freedesktop.org/gnu-grub/grub.git";
    tag = "grub-${version}";
    hash = "sha256-SB0clzmoqlwolHdgbPwJQv51WNWtdFafsL0T4hDjQf0=";
  };

  patches =
    let
      grubPatch = commit: "https://gitlab.freedesktop.org/gnu-grub/grub/-/commit/${commit}.patch";
    in
    [
      ./fix-bash-completion.patch
      ./add-hidden-menu-entries.patch
      ./bootstrap-po-downloads.patch
    ];

  postPatch = ''
    ${
      if kbdcompSupport then
        ''
          sed -i util/grub-kbdcomp.in -e 's@\bckbcomp\b@${ckbcomp}/bin/ckbcomp@'
        ''
      else
        ''
          echo '#! ${runtimeShell}' > util/grub-kbdcomp.in
          echo 'echo "Compile grub2 with { kbdcompSupport = true; } to enable support for this command."' >> util/grub-kbdcomp.in
        ''
    }

    GNULIB_REVISION=$(. bootstrap.conf; echo $GNULIB_REVISION)
    if [ "$GNULIB_REVISION" != ${gnulib.rev} ]; then
      echo "This version of GRUB requires a different gnulib revision!"
      echo "We have: ${gnulib.rev}"
      echo "GRUB needs: $GNULIB_REVISION"
      exit 1
    fi
  '';

  depsBuildBuild = [
    buildPackages.stdenv.cc
    pkg-config
  ];
  nativeBuildInputs = [
    bison
    flex
    python3
    pkg-config
    gettext
    freetype
    autoconf
    autoconf-archive
    automake
    help2man
  ];
  buildInputs = [
    ncurses
    libusb-compat-0_1
    freetype
    lvm2
    fuse3
    xz
    libtool
    bash
  ]
  ++ lib.optional doCheck qemu
  ++ lib.optional zfsSupport zfs;

  strictDeps = true;

  # glibc 2.43 C23 const-preserving strchr/strstr macros
  env.NIX_CFLAGS_COMPILE = "-Wno-error=discarded-qualifiers";

  hardeningDisable = [ "all" ];

  separateDebugInfo = !xenSupport;

  preConfigure = ''
    for i in "tests/util/"*.in
    do
      sed -i "$i" -e's|/bin/bash|${stdenv.shell}|g'
    done

    # Apparently, the QEMU executable is no longer called
    # `qemu-system-i386', even on i386.
    #
    # In addition, use `-nodefaults' to avoid errors like:
    #
    #  chardev: opening backend "stdio" failed
    #  qemu: could not open serial device 'stdio': Invalid argument
    #
    # See <http://www.mail-archive.com/qemu-devel@nongnu.org/msg22775.html>.
    sed -i "tests/util/grub-shell.in" \
        -e's/qemu-system-i386/qemu-system-x86_64 -nodefaults/g'

    patchShebangs .

    cp -f --no-preserve=mode ${locales}/po/LINGUAS ${locales}/po/*.po po
    mkdir po/.reference
    cp -f --no-preserve=mode ${locales}/po/*.po po/.reference

    ./bootstrap --no-git --gnulib-srcdir=${gnulib}

    substituteInPlace ./configure --replace-fail '/usr/share/fonts' '${unifont}/share/fonts'
  ''
  # build-grub-mkfont is built & run during build, need to find freetype for buildPlatform
  + lib.optionalString (!lib.systems.equals stdenv.buildPlatform stdenv.hostPlatform) ''
    configureFlagsArray+=(
      "BUILD_PKG_CONFIG=$PKG_CONFIG_FOR_BUILD"
    )
  '';

  configureFlags = [
    "--enable-grub-mount" # dep of os-prober
  ]
  ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    # grub doesn't do cross-compilation as usual and tries to use unprefixed
    # tools to target the host. Provide toolchain information explicitly for
    # cross builds.
    #
    # Ref: # https://github.com/buildroot/buildroot/blob/master/boot/grub2/grub2.mk#L108
    "TARGET_CC=${stdenv.cc.targetPrefix}cc"
    "TARGET_NM=${stdenv.cc.targetPrefix}nm"
    "TARGET_OBJCOPY=${stdenv.cc.targetPrefix}objcopy"
    "TARGET_RANLIB=${stdenv.cc.targetPrefix}ranlib"
    "TARGET_STRIP=${stdenv.cc.targetPrefix}strip"
  ]
  ++ lib.optional zfsSupport "--enable-libzfs"
  ++ lib.optionals efiSupport [
    "--with-platform=efi"
    "--target=${efiSystemsBuild.${stdenv.hostPlatform.system}.target}"
    "--program-prefix="
  ]
  ++ lib.optionals ieee1275Support [
    "--with-platform=ieee1275"
    "--target=${ieee1275SystemsBuild.${stdenv.hostPlatform.system}.target}"
  ]
  ++ lib.optionals xenSupport [
    "--with-platform=xen"
    "--target=${xenSystemsBuild.${stdenv.hostPlatform.system}.target}"
  ]
  ++ lib.optionals xenPvhSupport [
    "--with-platform=xen_pvh"
    "--target=${xenPvhSystemsBuild.${stdenv.hostPlatform.system}.target}"
  ]
  ++ lib.optionals corebootSupport [
    "--with-platform=coreboot"
    "--target=${corebootSystemsBuild.${stdenv.hostPlatform.system}.target}"
    "--enable-boot-time" # Log boot times. Might be useful for debugging loading issues.
  ];

  # save target that grub is compiled for
  grubTarget =
    if efiSupport then
      "${efiSystemsInstall.${stdenv.hostPlatform.system}.target}-efi"
    else if ieee1275Support then
      "${ieee1275SystemsBuild.${stdenv.hostPlatform.system}.target}-ieee1275"
    else if corebootSupport then
      "${corebootSystemsBuild.${stdenv.hostPlatform.system}.target}-coreboot"
    else
      lib.optionalString inPCSystems "${pcSystems.${stdenv.hostPlatform.system}.target}-pc";

  doCheck = false;
  enableParallelBuilding = true;

  postInstall = ''
    # We have to do this or else closure size balloons up

    patchShebangs $out/lib/grub/*/modinfo.sh
    sed -i $out/lib/grub/*/modinfo.sh -e "/grub_target_cppflags=/ s|'.*'|' '|"
  '';

  passthru.tests = {
    nixos-grub = nixosTests.grub;
    nixos-install-simple = nixosTests.installer.simple;
    nixos-install-grub-uefi = nixosTests.installer.simpleUefiGrub;
    nixos-install-grub-uefi-spec = nixosTests.installer.simpleUefiGrubSpecialisation;
  };

  meta = {
    description = "GNU GRUB, the Grand Unified Boot Loader";

    longDescription = ''
      GNU GRUB is a Multiboot boot loader. It was derived from GRUB, GRand
      Unified Bootloader, which was originally designed and implemented by
      Erich Stefan Boleyn.

      Briefly, the boot loader is the first software program that runs when a
      computer starts.  It is responsible for loading and transferring
      control to the operating system kernel software (such as the Hurd or
      the Linux).  The kernel, in turn, initializes the rest of the
      operating system (e.g., GNU).
    '';

    homepage = "https://www.gnu.org/software/grub/";

    license = lib.licenses.gpl3Plus;

    platforms =
      if efiSupport then
        lib.attrNames efiSystemsBuild
      else if ieee1275Support then
        lib.attrNames ieee1275SystemsBuild
      else if xenSupport then
        lib.attrNames xenSystemsBuild
      else if xenPvhSupport then
        lib.attrNames xenPvhSystemsBuild
      else if corebootSupport then
        lib.attrNames corebootSystemsBuild
      else
        lib.platforms.gnu ++ lib.platforms.linux;

    maintainers = [ ];
  };
}
