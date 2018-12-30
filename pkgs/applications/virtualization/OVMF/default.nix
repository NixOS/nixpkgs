{ stdenv, lib, edk2, nasm, iasl, seabios, openssl, secureBoot ? false }:

let
  projectDscPath = if stdenv.isi686 then
    "OvmfPkg/OvmfPkgIa32.dsc"
  else if stdenv.isx86_64 then
    "OvmfPkg/OvmfPkgX64.dsc"
  else if stdenv.isAarch64 || stdenv.isAarch32 then
    "ArmVirtPkg/ArmVirtQemu.dsc"
  else
    throw "Unsupported architecture";

  crossCompiling = stdenv.buildPlatform != stdenv.hostPlatform;

  version = (builtins.parseDrvName edk2.name).version;

  inherit (edk2) src targetArch;

  buildFlags = if stdenv.isAarch64 then ""
    else if seabios == null then ''${lib.optionalString secureBoot "-DSECURE_BOOT_ENABLE=TRUE"}''
    else ''-D CSM_ENABLE -D FD_SIZE_2MB ${lib.optionalString secureBoot "-DSECURE_BOOT_ENABLE=TRUE"}'';
in

stdenv.mkDerivation (edk2.setup projectDscPath {
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

    ${if stdenv.isAarch64 || stdenv.isAarch32 then ''
      ln -sv ${src}/ArmPkg .
      ln -sv ${src}/ArmPlatformPkg .
      ln -sv ${src}/ArmVirtPkg .
      ln -sv ${src}/EmbeddedPkg .
      ln -sv ${src}/OvmfPkg .
    '' else if seabios != null then ''
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

  buildPhase = lib.optionalString crossCompiling ''
    # This is required, even though it is set in target.txt in edk2/default.nix.
    export EDK2_TOOLCHAIN=GCC49

    # Configures for cross-compiling
    export ''${EDK2_TOOLCHAIN}_${targetArch}_PREFIX=${stdenv.targetPlatform.config}-
    export EDK2_HOST_ARCH=${targetArch}
    '' + ''
    build \
      -n $NIX_BUILD_CORES \
      ${buildFlags} \
      -a ${targetArch} \
      ${lib.optionalString crossCompiling "-t $EDK2_TOOLCHAIN"}
  '';

  postFixup = if stdenv.isAarch64 || stdenv.isAarch32 then ''
    mkdir -vp $fd/FV
    mkdir -vp $fd/AAVMF
    mv -v $out/FV/QEMU_{EFI,VARS}.fd $fd/FV

    # Uses Fedora dir layout: https://src.fedoraproject.org/cgit/rpms/edk2.git/tree/edk2.spec
    # FIXME: why is it different from Debian dir layout? https://anonscm.debian.org/cgit/pkg-qemu/edk2.git/tree/debian/rules
    dd of=$fd/AAVMF/QEMU_EFI-pflash.raw       if=/dev/zero bs=1M    count=64
    dd of=$fd/AAVMF/QEMU_EFI-pflash.raw       if=$fd/FV/QEMU_EFI.fd conv=notrunc
    dd of=$fd/AAVMF/vars-template-pflash.raw if=/dev/zero bs=1M    count=64
  '' else ''
    mkdir -vp $OUTPUT_FD/FV
    mv -v $out/FV/OVMF{,_CODE,_VARS}.fd $OUTPUT_FD/FV
  '';

  dontPatchELF = true;

  meta = {
    description = "Sample UEFI firmware for QEMU and KVM";
    homepage = https://github.com/tianocore/tianocore.github.io/wiki/OVMF;
    license = stdenv.lib.licenses.bsd2;
    platforms = ["x86_64-linux" "i686-linux" "aarch64-linux" "armv7l-linux"];
  };
})
