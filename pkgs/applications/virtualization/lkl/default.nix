{ lib, stdenv, fetchFromGitHub, bc, python3, bison, flex, fuse, libarchive
, buildPackages

, firewallSupport ? false
}:

stdenv.mkDerivation rec {
  pname = "lkl";

  # NOTE: pinned to the last known version that doesn't have a hang in cptofs.
  # Please verify `nix build -f nixos/release-combined.nix nixos.ova` works
  # before attempting to update again.
  # ref: https://github.com/NixOS/nixpkgs/pull/219434
  version = "2022-08-08";

  outputs = [ "dev" "lib" "out" ];

  src = fetchFromGitHub {
    owner  = "lkl";
    repo   = "linux";
    rev  = "ffbb4aa67b3e0a64f6963f59385a200d08cb2d8b";
    sha256 = "sha256-24sNREdnhkF+P+3P0qEh2tF1jHKF7KcbFSn/rPK2zWs=";
  };

  nativeBuildInputs = [ bc bison flex python3 ];

  buildInputs = [ fuse libarchive ];

  postPatch = ''
    # Fix a /usr/bin/env reference in here that breaks sandboxed builds
    patchShebangs arch/lkl/scripts

    patchShebangs scripts/ld-version.sh

    # Fixup build with newer Linux headers: https://github.com/lkl/linux/pull/484
    sed '1i#include <linux/sockios.h>' -i tools/lkl/lib/hijack/xlate.c
  '' + lib.optionalString firewallSupport ''
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

  # We turn off format and fortify because of these errors (fortify implies -O2, which breaks the jitter entropy code):
  #   fs/xfs/xfs_log_recover.c:2575:3: error: format not a string literal and no format arguments [-Werror=format-security]
  #   crypto/jitterentropy.c:54:3: error: #error "The CPU Jitter random number generator must not be compiled with optimizations. See documentation. Use the compiler switch -O0 for compiling jitterentropy.c."
  hardeningDisable = [ "format" "fortify" ];

  # Fixes the following error when using liblkl-hijack.so on aarch64-linux:
  # symbol lookup error: liblkl-hijack.so: undefined symbol: __aarch64_ldadd4_sync
  env.NIX_CFLAGS_LINK = "-lgcc_s";

  makeFlags = [
    "-C tools/lkl"
    "CC=${stdenv.cc}/bin/${stdenv.cc.targetPrefix}cc"
    "HOSTCC=${buildPackages.stdenv.cc}/bin/${buildPackages.stdenv.cc.targetPrefix}cc"
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "The Linux kernel as a library";
    longDescription = ''
      LKL (Linux Kernel Library) aims to allow reusing the Linux kernel code as
      extensively as possible with minimal effort and reduced maintenance
      overhead
    '';
    homepage    = "https://github.com/lkl/linux/";
    platforms   = platforms.linux; # Darwin probably works too but I haven't tested it
    license     = licenses.gpl2;
    maintainers = with maintainers; [ copumpkin raitobezarius ];
  };
}
