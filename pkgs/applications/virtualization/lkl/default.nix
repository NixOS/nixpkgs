{ lib, stdenv, fetchFromGitHub, bc, python3, bison, flex, fuse, libarchive
, buildPackages }:

stdenv.mkDerivation rec {
  pname = "lkl";
  version = "2022-05-18";

  outputs = [ "dev" "lib" "out" ];

  src = fetchFromGitHub {
    owner  = "lkl";
    repo   = "linux";
    rev  = "10c7b5dee8c424cc2ab754e519ecb73350283ff9";
    sha256 = "sha256-D3HQdKzhB172L62a+8884bNhcv7vm/c941wzbYtbf4I=";
  };

  nativeBuildInputs = [ bc bison flex python3 ];

  buildInputs = [ fuse libarchive ];

  postPatch = ''
    # Fix a /usr/bin/env reference in here that breaks sandboxed builds
    patchShebangs arch/lkl/scripts

    patchShebangs scripts/ld-version.sh

    # Fixup build with newer Linux headers: https://github.com/lkl/linux/pull/484
    sed '1i#include <linux/sockios.h>' -i tools/lkl/lib/hijack/xlate.c
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
    maintainers = with maintainers; [ copumpkin ];
  };
}
