{ stdenv, nixosTests, lib, edk2, util-linux, nasm, acpica-tools, llvmPackages
, fetchurl, python3, pexpect, xorriso, qemu, dosfstools, mtools
, csmSupport ? false, seabios
, fdSize2MB ? csmSupport
, fdSize4MB ? secureBoot
, secureBoot ? false
, systemManagementModeRequired ? secureBoot && stdenv.hostPlatform.isx86
# Whether to create an nvram variables template
# which includes the MSFT secure boot keys
, msVarsTemplate ? false
# When creating the nvram variables template with
# the MSFT keys, we also must provide a certificate
# to use as the PK and first KEK for the keystore.
#
# By default, we use Debian's cert. This default
# should chnage to a NixOS cert once we have our
# own secure boot signing infrastructure.
#
# Ignored if msVarsTemplate is false.
, vendorPkKek ? "$NIX_BUILD_TOP/debian/PkKek-1-Debian.pem"
, httpSupport ? false
, tpmSupport ? false
, tlsSupport ? false
, debug ? false
# Usually, this option is broken, do not use it except if you know what you are
# doing.
, sourceDebug ? false
}:

let

  projectDscPath = if stdenv.isi686 then
    "OvmfPkg/OvmfPkgIa32.dsc"
  else if stdenv.isx86_64 then
    "OvmfPkg/OvmfPkgX64.dsc"
  else if stdenv.hostPlatform.isAarch then
    "ArmVirtPkg/ArmVirtQemu.dsc"
  else if stdenv.hostPlatform.isRiscV then
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

  OvmfPkKek1AppPrefix = "4e32566d-8e9e-4f52-81d3-5bb9715f9727";

  debian-edk-src = fetchurl {
    url = "http://deb.debian.org/debian/pool/main/e/edk2/edk2_2023.11-5.debian.tar.xz";
    sha256 = "1yxlab4md30pxvjadr6b4xn6cyfw0c292q63pyfv4vylvhsb24g4";
  };

  buildPrefix = "Build/*/*";

in

assert systemManagementModeRequired -> stdenv.hostPlatform.isx86;
assert msVarsTemplate -> fdSize4MB;
# TODO: Support other platforms.
#
# Need to set the --flavor flag to edk2-vars-generator
# (currently supports AAVMF, but not RISCV_VIRT), and
# need to adjust the locations passed to edk2-vars-generator.
assert msVarsTemplate -> stdenv.isx86_64;

edk2.mkDerivation projectDscPath (finalAttrs: {
  pname = "OVMF";
  inherit version;

  outputs = [ "out" "fd" ];

  nativeBuildInputs = [ util-linux nasm acpica-tools ]
    ++ lib.optionals stdenv.cc.isClang [ llvmPackages.bintools llvmPackages.llvm ]
    ++ lib.optionals msVarsTemplate [ python3 pexpect xorriso qemu dosfstools mtools ];
  strictDeps = true;

  hardeningDisable = [ "format" "stackprotector" "pic" "fortify" ];

  buildFlags =
    # IPv6 has no reason to be disabled.
    [ "-D NETWORK_IP6_ENABLE=TRUE" ]
    ++ lib.optionals debug [ "-D DEBUG_ON_SERIAL_PORT=TRUE" ]
    ++ lib.optionals sourceDebug [ "-D SOURCE_DEBUG_ENABLE=TRUE" ]
    ++ lib.optionals secureBoot [ "-D SECURE_BOOT_ENABLE=TRUE" ]
    ++ lib.optionals systemManagementModeRequired [ "-D SMM_REQUIRE=TRUE" ]
    ++ lib.optionals csmSupport [ "-D CSM_ENABLE" ]
    ++ lib.optionals fdSize2MB ["-D FD_SIZE_2MB"]
    ++ lib.optionals fdSize4MB ["-D FD_SIZE_4MB"]
    ++ lib.optionals httpSupport [ "-D NETWORK_HTTP_ENABLE=TRUE" "-D NETWORK_HTTP_BOOT_ENABLE=TRUE" ]
    ++ lib.optionals tlsSupport [ "-D NETWORK_TLS_ENABLE=TRUE" ]
    ++ lib.optionals tpmSupport [ "-D TPM_ENABLE" "-D TPM2_ENABLE" "-D TPM2_CONFIG_ENABLE"];

  buildConfig = if debug then "DEBUG" else "RELEASE";
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Qunused-arguments";

  env.PYTHON_COMMAND = "python3";

  postUnpack = lib.optionalDrvAttr msVarsTemplate ''
    unpackFile ${debian-edk-src}
  '';

  postPatch = lib.optionalString csmSupport ''
    cp ${seabios}/share/seabios/Csm16.bin OvmfPkg/Csm/Csm16/Csm16.bin
  '';

  postConfigure = lib.optionalDrvAttr msVarsTemplate ''
    tr -d '\n' < ${vendorPkKek} | sed \
      -e 's/.*-----BEGIN CERTIFICATE-----/${OvmfPkKek1AppPrefix}:/' \
      -e 's/-----END CERTIFICATE-----//' > vendor-cert-string
    export PYTHONPATH=$NIX_BUILD_TOP/debian/python:$PYTHONPATH
  '';

  postBuild = lib.optionalDrvAttr msVarsTemplate ''
    python3 $NIX_BUILD_TOP/debian/edk2-vars-generator.py \
      --flavor OVMF_4M \
      --enrolldefaultkeys ${buildPrefix}/X64/EnrollDefaultKeys.efi \
      --shell ${buildPrefix}/X64/Shell.efi \
      --code ${buildPrefix}/FV/OVMF_CODE.fd \
      --vars-template ${buildPrefix}/FV/OVMF_VARS.fd \
      --certificate `< vendor-cert-string` \
      --out-file OVMF_VARS.ms.fd
  '';

  postInstall = lib.optionalDrvAttr msVarsTemplate ''
    mkdir -vp $fd/FV
    install -v -m644 OVMF_VARS.ms.fd $fd/FV
    ln -sv $fd/FV/OVMF_CODE{,.ms}.fd
  '';

  postFixup = (
    if stdenv.hostPlatform.isAarch then ''
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
  ''
  else if stdenv.hostPlatform.isRiscV then ''
    mkdir -vp $fd/FV

    mv -v $out/FV/RISCV_VIRT_{CODE,VARS}.fd $fd/FV/
    truncate -s 32M $fd/FV/RISCV_VIRT_CODE.fd
    truncate -s 32M $fd/FV/RISCV_VIRT_VARS.fd
  ''
  else ''
    mkdir -vp $fd/FV
    mv -v $out/FV/OVMF{,_CODE,_VARS}.fd $fd/FV
  '');

  dontPatchELF = true;

  passthru =
  let
    cpuName = stdenv.hostPlatform.parsed.cpu.name;
    suffix = suffixes."${cpuName}" or (throw "Host cpu name `${cpuName}` is not supported in this OVMF derivation!");
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
    maintainers = with lib.maintainers; [ adamcstephens raitobezarius ];
    broken = stdenv.isDarwin;
  };
})
