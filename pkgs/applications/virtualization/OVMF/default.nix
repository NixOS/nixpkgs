{ stdenv, lib, edk2, nasm, iasl, seabios, openssl, secureBoot ? false }:

let

  targetArch = if stdenv.isi686 then
    "Ia32"
  else if stdenv.isx86_64 then
    "X64"
  else
    throw "Unsupported architecture";

  version = (builtins.parseDrvName edk2.name).version;

  src = edk2.src;
in

stdenv.mkDerivation (edk2.setup "OvmfPkg/OvmfPkg${targetArch}.dsc" {
  name = "OVMF-${version}";

  inherit src;

  outputs = [ "out" "fd" ];

  # TODO: properly include openssl for secureBoot
  buildInputs = [nasm iasl] ++ stdenv.lib.optionals (secureBoot == true) [ openssl ];

  hardeningDisable = [ "stackprotector" "pic" "fortify" ];

  unpackPhase = ''
    # $fd is overwritten during the build
    export OUTPUT_FD=$fd

    for file in \
      "${src}"/{UefiCpuPkg,MdeModulePkg,IntelFrameworkModulePkg,PcAtChipsetPkg,FatBinPkg,EdkShellBinPkg,MdePkg,ShellPkg,OptionRomPkg,IntelFrameworkPkg,FatPkg,CryptoPkg,SourceLevelDebugPkg};
    do
      ln -sv "$file" .
    done

    ${if seabios != null then ''
        cp -r ${src}/OvmfPkg .
        chmod +w OvmfPkg/Csm/Csm16
        cp ${seabios}/Csm16.bin OvmfPkg/Csm/Csm16/Csm16.bin
    '' else ''
        ln -sv ${src}/OvmfPkg .
    ''}

    ${lib.optionalString secureBoot ''
      ln -sv ${src}/SecurityPkg .
      ln -sv ${src}/CryptoPkg .
    ''}
  '';

  buildPhase = if seabios == null then ''
      build ${lib.optionalString secureBoot "-DSECURE_BOOT_ENABLE=TRUE"}
    '' else ''
      build -D CSM_ENABLE -D FD_SIZE_2MB ${lib.optionalString secureBoot "-DSECURE_BOOT_ENABLE=TRUE"}
    '';

  postFixup = ''
    mkdir -vp $OUTPUT_FD/FV
    mv -v $out/FV/OVMF{,_CODE,_VARS}.fd $OUTPUT_FD/FV
  '';

  dontPatchELF = true;

  meta = {
    description = "Sample UEFI firmware for QEMU and KVM";
    homepage = https://sourceforge.net/apps/mediawiki/tianocore/index.php?title=OVMF;
    license = stdenv.lib.licenses.bsd2;
    platforms = ["x86_64-linux" "i686-linux"];
  };
})
