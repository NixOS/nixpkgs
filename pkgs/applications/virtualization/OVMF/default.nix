{ stdenv, edk2 }:

stdenv.mkDerivation (edk2.setup "OvmfPkg/OvmfPkgX64.dsc" {
  name = "OVMF-2012-03-13";

  src = edk2.src;
  
  patchPhase = ''
    rm -fR Conf BaseTools EdkCompatibilityPkg
  '';

  meta = {
    description = "Sample UEFI firmware for QEMU and KVM";
    homepage = http://sourceforge.net/apps/mediawiki/tianocore/index.php?title=OVMF;
    license = "BSD";
    maintainers = [ stdenv.lib.maintainers.shlevy ];
    platforms = ["x86_64-linux" "i686-linux"];
  };
})
