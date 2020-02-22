{ stdenv, fetchFromGitHub, bc, python, bison, flex, fuse, libarchive
, buildPackages }:

stdenv.mkDerivation rec {
  pname = "lkl";
  version = "2019-10-04";
  rev  = "06ca3ddb74dc5b84fa54fa1746737f2df502e047";

  outputs = [ "dev" "lib" "out" ];

  nativeBuildInputs = [ bc bison flex python ];

  buildInputs = [ fuse libarchive ];

  src = fetchFromGitHub {
    inherit rev;
    owner  = "lkl";
    repo   = "linux";
    sha256 = "0qjp0r338bwgrqdsvy5mkdh7ryas23m47yvxfwdknfyl0k3ylq62";
  };

  # Fix a /usr/bin/env reference in here that breaks sandboxed builds
  prePatch = "patchShebangs arch/lkl/scripts";
  # Fixup build with newer Linux headers: https://github.com/lkl/linux/pull/484
  postPatch = "sed '1i#include <linux/sockios.h>' -i tools/lkl/lib/hijack/xlate.c";

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

  meta = with stdenv.lib; {
    description = "The Linux kernel as a library";
    longDescription = ''
      LKL (Linux Kernel Library) aims to allow reusing the Linux kernel code as
      extensively as possible with minimal effort and reduced maintenance
      overhead
    '';
    homepage    = https://github.com/lkl/linux/;
    platforms   = [ "x86_64-linux" "aarch64-linux" "armv7l-linux" "armv6l-linux" ]; # Darwin probably works too but I haven't tested it
    license     = licenses.gpl2;
    maintainers = with maintainers; [ copumpkin ];
  };
}
