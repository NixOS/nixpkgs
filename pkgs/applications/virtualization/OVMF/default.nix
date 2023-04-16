{ stdenv, nixosTests, lib, edk2, util-linux, nasm, acpica-tools, llvmPackages
, csmSupport ? false, seabios ? null
, secureBoot ? false
, httpSupport ? false
, tpmSupport ? false
}:

assert csmSupport -> seabios != null;

let

  projectDscPath = if stdenv.isi686 then
    "OvmfPkg/OvmfPkgIa32.dsc"
  else if stdenv.isx86_64 then
    "OvmfPkg/OvmfPkgX64.dsc"
  else if stdenv.hostPlatform.isAarch then
    "ArmVirtPkg/ArmVirtQemu.dsc"
  else if stdenv.hostPlatform.isRiscV64 then
    "OvmfPkg/RiscVVirt/RiscVVirtQemu.dsc"
  else
    throw "Unsupported architecture";

  version = lib.getVersion edk2;

  suffixes = {
    i686 = "FV/OVMF";
    x86_64 = "FV/OVMF";
    aarch64 = "FV/AAVMF";
    riscv64 = "FV/RISCV_VIRT";
  };

  cpuName = stdenv.hostPlatform.parsed.cpu.name;
  suffix = suffixes."${cpuName}" or (throw "Host cpu name `${cpuName}` is not supported in this OVMF derivation!");
in

edk2.mkDerivation projectDscPath (finalAttrs: {
  pname = "OVMF";
  inherit version;

  outputs = [ "out" "fd" ];

  nativeBuildInputs = [ util-linux nasm acpica-tools ]
    ++ lib.optionals stdenv.cc.isClang [ llvmPackages.bintools llvmPackages.llvm ];
  strictDeps = true;

  hardeningDisable = [ "format" "stackprotector" "pic" "fortify" ];

  buildFlags =
    lib.optionals secureBoot [ "-D SECURE_BOOT_ENABLE=TRUE" ]
    ++ lib.optionals csmSupport [ "-D CSM_ENABLE" "-D FD_SIZE_2MB" ]
    ++ lib.optionals httpSupport [ "-D NETWORK_HTTP_ENABLE=TRUE" "-D NETWORK_HTTP_BOOT_ENABLE=TRUE" ]
    ++ lib.optionals tpmSupport [ "-D TPM_ENABLE" "-D TPM2_ENABLE" "-D TPM2_CONFIG_ENABLE"];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Qunused-arguments";

  postPatch = lib.optionalString csmSupport ''
    cp ${seabios}/Csm16.bin OvmfPkg/Csm/Csm16/Csm16.bin
  '';

  # FIXME: remove me when https://github.com/tianocore/edk2/pull/4275 lands in a stable release.
  patches = [
    ./0001-RiscVVirt-support-split-code-and-vars-binaries.patch
  ];

  postFixup =
  let
    shortName = builtins.elemAt (lib.splitString "/" suffix) 1;
  in ''
    mkdir -vp $fd/FV
    mkdir -vp $fd/${suffix}
    mkdir -vp $fd/${shortName}
    mv -v $out/FV/QEMU_{EFI,VARS}.fd $fd/FV

    # Use Debian dir layout: https://salsa.debian.org/qemu-team/edk2/blob/debian/debian/rules
    dd of=$fd/${suffix}_CODE.fd  if=/dev/zero bs=1M    count=64
    dd of=$fd/${suffix}_CODE.fd  if=$fd/FV/QEMU_EFI.fd conv=notrunc
    dd of=$fd/${suffix}_VARS.fd  if=/dev/zero bs=1M    count=64

    # Also add symlinks for Fedora dir layout: https://src.fedoraproject.org/cgit/rpms/edk2.git/tree/edk2.spec
    ln -sf $fd/${suffix}_CODE.fd $fd/${shortName}/QEMU_EFI-pflash.raw
    ln -sf $fd/${suffix}_VARS.fd $fd/${shortName}/vars-template-pflash.raw
  '';

  dontPatchELF = true;

  passthru =
  let
    prefix = "${finalAttrs.finalPackage.fd}/${suffix}";
  in {
    firmware  = "${prefix}_CODE.fd";
    variables = "${prefix}_VARS.fd";
    # This will test the EFI firmware for the host platform as part of the NixOS Tests setup.
    tests.basic-systemd-boot = nixosTests.systemd-boot.basic;
  };

  meta = {
    description = "Sample UEFI firmware for QEMU and KVM";
    homepage = "https://github.com/tianocore/tianocore.github.io/wiki/OVMF";
    license = lib.licenses.bsd2;
    inherit (edk2.meta) platforms;
    maintainers = [ lib.maintainers.raitobezarius ];
  };
})
