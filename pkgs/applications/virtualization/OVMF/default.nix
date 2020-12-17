{ stdenv, lib, edk2, util-linux, nasm, iasl
, csmSupport ? false, seabios ? null
, secureBoot ? false
}:

assert csmSupport -> seabios != null;

let

  projectDscPath = if stdenv.isi686 then
    "OvmfPkg/OvmfPkgIa32.dsc"
  else if stdenv.isx86_64 then
    "OvmfPkg/OvmfPkgX64.dsc"
  else if stdenv.isAarch64 then
    "ArmVirtPkg/ArmVirtQemu.dsc"
  else
    throw "Unsupported architecture";

  version = lib.getVersion edk2;
in

edk2.mkDerivation projectDscPath {
  name = "OVMF-${version}";

  outputs = [ "out" "fd" ];

  buildInputs = [ util-linux nasm iasl ];

  hardeningDisable = [ "format" "stackprotector" "pic" "fortify" ];

  buildFlags =
    lib.optional secureBoot "-DSECURE_BOOT_ENABLE=TRUE"
    ++ lib.optionals csmSupport [ "-D CSM_ENABLE" "-D FD_SIZE_2MB" ];

  postPatch = lib.optionalString csmSupport ''
    cp ${seabios}/Csm16.bin OvmfPkg/Csm/Csm16/Csm16.bin
  '';

  postFixup = if stdenv.isAarch64 then ''
    mkdir -vp $fd/FV
    mkdir -vp $fd/AAVMF
    mv -v $out/FV/QEMU_{EFI,VARS}.fd $fd/FV

    # Use Debian dir layout: https://salsa.debian.org/qemu-team/edk2/blob/debian/debian/rules
    dd of=$fd/FV/AAVMF_CODE.fd  if=/dev/zero bs=1M    count=64
    dd of=$fd/FV/AAVMF_CODE.fd  if=$fd/FV/QEMU_EFI.fd conv=notrunc
    dd of=$fd/FV/AAVMF_VARS.fd  if=/dev/zero bs=1M    count=64

    # Also add symlinks for Fedora dir layout: https://src.fedoraproject.org/cgit/rpms/edk2.git/tree/edk2.spec
    ln -s $fd/FV/AAVMF_CODE.fd $fd/AAVMF/QEMU_EFI-pflash.raw
    ln -s $fd/FV/AAVMF_VARS.fd $fd/AAVMF/vars-template-pflash.raw
  '' else ''
    mkdir -vp $fd/FV
    mv -v $out/FV/OVMF{,_CODE,_VARS}.fd $fd/FV
  '';

  dontPatchELF = true;

  meta = {
    description = "Sample UEFI firmware for QEMU and KVM";
    homepage = "https://github.com/tianocore/tianocore.github.io/wiki/OVMF";
    license = stdenv.lib.licenses.bsd2;
    platforms = ["x86_64-linux" "i686-linux" "aarch64-linux" "x86_64-darwin"];
  };
}
