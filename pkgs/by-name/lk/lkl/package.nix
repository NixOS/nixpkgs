{
  lib,
  stdenv,
  fetchFromGitHub,
  bc,
  python3,
  bison,
  flex,
  fuse3,
  libarchive,
  buildPackages,

  firewallSupport ? false,
}:

stdenv.mkDerivation {
  pname = "lkl";

  version = "2025-03-20";

  outputs = [
    "dev"
    "lib"
    "out"
  ];

  src = fetchFromGitHub {
    owner = "lkl";
    repo = "linux";
    rev = "fd33ab3d21a99a31683ebada5bd3db3a54a58800";
    sha256 = "sha256-3uPkOyL/hoA/H2gKrEEDsuJvwOE2x27vxY5Y2DyNNxU=";
  };

  nativeBuildInputs = [
    bc
    bison
    flex
    python3
  ];

  buildInputs = [
    fuse3
    libarchive
  ];

  patches = [
    # Fix corruption in hijack and zpoline libraries when building in parallel,
    # because both hijack and zpoline share object files, which may result in
    # missing symbols.
    # https://github.com/lkl/linux/pull/612/commits/4ee5d9b78ca1425b4473ede98602b656f28027e8
    ./fix-hijack-and-zpoline-parallel-builds.patch
  ];

  postPatch = ''
    # Fix a /usr/bin/env reference in here that breaks sandboxed builds
    patchShebangs arch/lkl/scripts

    patchShebangs scripts/ld-version.sh

    # Fixup build with newer Linux headers: https://github.com/lkl/linux/pull/484
    sed '1i#include <linux/sockios.h>' -i tools/lkl/lib/hijack/xlate.c
  ''
  + lib.optionalString (stdenv.hostPlatform.isi686 || stdenv.hostPlatform.isLoongArch64) ''
    echo CONFIG_KALLSYMS=n >> arch/lkl/configs/defconfig
    echo CONFIG_KALLSYMS_BASE_RELATIVE=n >> arch/lkl/configs/defconfig
  ''
  + lib.optionalString firewallSupport ''
    cat ${./lkl-defconfig-enable-nftables} >> arch/lkl/configs/defconfig
  '';

  installPhase = ''
    mkdir -p $out/bin $lib/lib $dev

    cp tools/lkl/bin/lkl-hijack.sh $out/bin
    sed -i $out/bin/lkl-hijack.sh \
        -e "s,LD_LIBRARY_PATH=.*,LD_LIBRARY_PATH=$lib/lib,"

    cp tools/lkl/{cptofs,fs2tar,lklfuse} $out/bin
    ln -s cptofs $out/bin/cpfromfs
    cp -r tools/lkl/include $dev/
    cp tools/lkl/liblkl.a \
       tools/lkl/lib/liblkl.so \
       tools/lkl/lib/hijack/liblkl-hijack.so $lib/lib
  '';

  postFixup = ''
    ln -s $out/bin/lklfuse $out/bin/mount.fuse.lklfuse
  '';

  # We turn off format and fortify because of these errors (fortify implies -O2, which breaks the jitter entropy code):
  #   fs/xfs/xfs_log_recover.c:2575:3: error: format not a string literal and no format arguments [-Werror=format-security]
  #   crypto/jitterentropy.c:54:3: error: #error "The CPU Jitter random number generator must not be compiled with optimizations. See documentation. Use the compiler switch -O0 for compiling jitterentropy.c."
  hardeningDisable = [
    "format"
    "fortify"
  ];

  # Fixes the following error when using liblkl-hijack.so on aarch64-linux:
  # symbol lookup error: liblkl-hijack.so: undefined symbol: __aarch64_ldadd4_sync
  env.NIX_CFLAGS_LINK = "-lgcc_s";

  # Fixes the following error when linking on loongarch64-linux:
  # ld: tools/lkl/liblkl.a(lkl.o): relocation R_LARCH_PCREL20_S2 overflow 0x200090
  # ld: recompile with 'gcc -mno-relax' or 'as -mno-relax' or 'ld --no-relax'
  # ld: final link failed: bad value
  env.NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isLoongArch64 "--no-relax";

  makeFlags = [
    "-C tools/lkl"
    "CC=${stdenv.cc}/bin/${stdenv.cc.targetPrefix}cc"
    "HOSTCC=${buildPackages.stdenv.cc}/bin/${buildPackages.stdenv.cc.targetPrefix}cc"
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Linux kernel as a library";
    longDescription = ''
      LKL (Linux Kernel Library) aims to allow reusing the Linux kernel code as
      extensively as possible with minimal effort and reduced maintenance
      overhead
    '';
    homepage = "https://github.com/lkl/linux/";
    platforms = platforms.linux; # Darwin probably works too but I haven't tested it
    license = licenses.gpl2;
    maintainers = with maintainers; [
      timschumi
    ];
  };
}
