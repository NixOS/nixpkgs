{ stdenv, edk2, nasm, iasl }:

let

  targetArch = if stdenv.isi686 then
    "Ia32"
  else if stdenv.isx86_64 then
    "X64"
  else
    throw "Unsupported architecture";

in

stdenv.mkDerivation (edk2.setup "OvmfPkg/OvmfPkg${targetArch}.dsc" {
  name = "OVMF-2014-12-10";

  buildInputs = [nasm iasl];
  unpackPhase = ''
    for file in \
      "${edk2.src}"/{OvmfPkg,UefiCpuPkg,MdeModulePkg,IntelFrameworkModulePkg,PcAtChipsetPkg,FatBinPkg,EdkShellBinPkg,MdePkg,ShellPkg,OptionRomPkg,IntelFrameworkPkg};
    do
      ln -sv "$file" .
    done
  '';

  meta = {
    description = "Sample UEFI firmware for QEMU and KVM";
    homepage = http://sourceforge.net/apps/mediawiki/tianocore/index.php?title=OVMF;
    license = stdenv.lib.licenses.bsd2;
    maintainers = [ stdenv.lib.maintainers.shlevy ];
    platforms = ["x86_64-linux" "i686-linux"];
  };
})
