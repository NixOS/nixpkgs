{ stdenv, edk2, nasm, iasl, seabios, openssl, secureBoot ? false }:

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

  # TODO: properly include openssl for secureBoot
  buildInputs = [nasm iasl] ++ stdenv.lib.optionals (secureBoot == true) [ openssl ];

  hardeningDisable = [ "stackprotector" "pic" "fortify" ];

  unpackPhase = ''
    for file in \
      "${edk2.src}"/{UefiCpuPkg,MdeModulePkg,IntelFrameworkModulePkg,PcAtChipsetPkg,FatBinPkg,EdkShellBinPkg,MdePkg,ShellPkg,OptionRomPkg,IntelFrameworkPkg};
    do
      ln -sv "$file" .
    done

    ${if (seabios == false) then ''
        ln -sv ${edk2.src}/OvmfPkg .
      '' else ''
        cp -r ${edk2.src}/OvmfPkg .
        chmod +w OvmfPkg/Csm/Csm16
        cp ${seabios}/Csm16.bin OvmfPkg/Csm/Csm16/Csm16.bin
      ''}

    ${if (secureBoot == true) then ''
        ln -sv ${edk2.src}/SecurityPkg .
        ln -sv ${edk2.src}/CryptoPkg .
      '' else ''
      ''}
    '';

  buildPhase = if (seabios == false) then ''
      build ${if secureBoot then "-DSECURE_BOOT_ENABLE=TRUE" else ""}
    '' else ''
      build -D CSM_ENABLE -D FD_SIZE_2MB ${if secureBoot then "-DSECURE_BOOT_ENABLE=TRUE" else ""}
    '';

  meta = {
    description = "Sample UEFI firmware for QEMU and KVM";
    homepage = http://sourceforge.net/apps/mediawiki/tianocore/index.php?title=OVMF;
    license = stdenv.lib.licenses.bsd2;
    platforms = ["x86_64-linux" "i686-linux"];
  };
})
