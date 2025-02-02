{ stdenv, nixosTests, lib, edk2, util-linux, nasm, acpica-tools, llvmPackages
, fetchFromGitLab, python3, pexpect, xorriso, qemu, dosfstools, mtools
, fdSize2MB ? false
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
# should change to a NixOS cert once we have our
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
, projectDscPath ? {
    i686 = "OvmfPkg/OvmfPkgIa32.dsc";
    x86_64 = "OvmfPkg/OvmfPkgX64.dsc";
    aarch64 = "ArmVirtPkg/ArmVirtQemu.dsc";
    riscv64 = "OvmfPkg/RiscVVirt/RiscVVirtQemu.dsc";
    loongarch64 = "OvmfPkg/LoongArchVirt/LoongArchVirtQemu.dsc";
  }.${stdenv.hostPlatform.parsed.cpu.name}
  or (throw "Unsupported OVMF `projectDscPath` on ${stdenv.hostPlatform.parsed.cpu.name}")
, fwPrefix ? {
    i686 = "OVMF";
    x86_64 = "OVMF";
    aarch64 = "AAVMF";
    riscv64 = "RISCV_VIRT";
    loongarch64 = "LOONGARCH_VIRT";
  }.${stdenv.hostPlatform.parsed.cpu.name}
  or (throw "Unsupported OVMF `fwPrefix` on ${stdenv.hostPlatform.parsed.cpu.name}")
, metaPlatforms ? edk2.meta.platforms
}:

let

  platformSpecific = {
    i686.msVarsArgs = {
      flavor = "OVMF";
      archDir = "Ia32";
    };
    x86_64.msVarsArgs = {
      flavor = "OVMF_4M";
      archDir = "X64";
    };
    aarch64.msVarsArgs = {
      flavor = "AAVMF";
      archDir = "AARCH64";
    };
  };

  cpuName = stdenv.hostPlatform.parsed.cpu.name;

  inherit (platformSpecific.${cpuName}) msVarsArgs;

  version = lib.getVersion edk2;

  OvmfPkKek1AppPrefix = "4e32566d-8e9e-4f52-81d3-5bb9715f9727";

  debian-edk-src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "qemu-team";
    repo = "edk2";
    nonConeMode = true;
    sparseCheckout = [
      "debian/edk2-vars-generator.py"
      "debian/python"
      "debian/PkKek-1-*.pem"
    ];
    rev = "refs/tags/debian/2024.05-1";
    hash = "sha256-uAjXJaHOVh944ZxcA2IgCsrsncxuhc0JKlsXs0E03s0=";
  };

  buildPrefix = "Build/*/*";

in

assert msVarsTemplate -> fdSize4MB;
assert msVarsTemplate -> platformSpecific ? ${cpuName};
assert msVarsTemplate -> platformSpecific.${cpuName} ? msVarsArgs;

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
    ++ lib.optionals fdSize2MB ["-D FD_SIZE_2MB"]
    ++ lib.optionals fdSize4MB ["-D FD_SIZE_4MB"]
    ++ lib.optionals httpSupport [ "-D NETWORK_HTTP_ENABLE=TRUE" "-D NETWORK_HTTP_BOOT_ENABLE=TRUE" ]
    ++ lib.optionals tlsSupport [ "-D NETWORK_TLS_ENABLE=TRUE" ]
    ++ lib.optionals tpmSupport [ "-D TPM_ENABLE" "-D TPM2_ENABLE" "-D TPM2_CONFIG_ENABLE"];

  buildConfig = if debug then "DEBUG" else "RELEASE";
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Qunused-arguments";

  env.PYTHON_COMMAND = "python3";

  postUnpack = lib.optionalDrvAttr msVarsTemplate ''
    ln -s ${debian-edk-src}/debian
  '';

  postConfigure = lib.optionalDrvAttr msVarsTemplate ''
    tr -d '\n' < ${vendorPkKek} | sed \
      -e 's/.*-----BEGIN CERTIFICATE-----/${OvmfPkKek1AppPrefix}:/' \
      -e 's/-----END CERTIFICATE-----//' > vendor-cert-string
    export PYTHONPATH=$NIX_BUILD_TOP/debian/python:$PYTHONPATH
  '';

  postBuild = lib.optionalString (stdenv.hostPlatform.isAarch || stdenv.hostPlatform.isLoongArch64) ''
    (
    cd ${buildPrefix}/FV
    cp QEMU_EFI.fd ${fwPrefix}_CODE.fd
    cp QEMU_VARS.fd ${fwPrefix}_VARS.fd
    )
  '' + lib.optionalString stdenv.hostPlatform.isAarch ''
    # QEMU expects 64MiB CODE and VARS files on ARM/AARCH64 architectures
    # Truncate the firmware files to the expected size
    truncate -s 64M ${buildPrefix}/FV/${fwPrefix}_CODE.fd
    truncate -s 64M ${buildPrefix}/FV/${fwPrefix}_VARS.fd
  '' + lib.optionalString stdenv.hostPlatform.isRiscV ''
    truncate -s 32M ${buildPrefix}/FV/${fwPrefix}_CODE.fd
    truncate -s 32M ${buildPrefix}/FV/${fwPrefix}_VARS.fd
  '' + lib.optionalString msVarsTemplate ''
    (
    cd ${buildPrefix}
    # locale must be set on Darwin for invocations of mtools to work correctly
    LC_ALL=C python3 $NIX_BUILD_TOP/debian/edk2-vars-generator.py \
      --flavor ${msVarsArgs.flavor} \
      --enrolldefaultkeys ${msVarsArgs.archDir}/EnrollDefaultKeys.efi \
      --shell ${msVarsArgs.archDir}/Shell.efi \
      --code FV/${fwPrefix}_CODE.fd \
      --vars-template FV/${fwPrefix}_VARS.fd \
      --certificate `< $NIX_BUILD_TOP/$sourceRoot/vendor-cert-string` \
      --out-file FV/${fwPrefix}_VARS.ms.fd
    )
  '';

  # TODO: Usage of -bios OVMF.fd is discouraged: https://lists.katacontainers.io/pipermail/kata-dev/2021-January/001650.html
  # We should remove the isx86-specifc block here once we're ready to update nixpkgs to stop using that and update the
  # release notes accordingly.
  postInstall = ''
    mkdir -vp $fd/FV
  '' + lib.optionalString (builtins.elem fwPrefix [
    "OVMF" "AAVMF" "RISCV_VIRT" "LOONGARCH_VIRT"
  ]) ''
    mv -v $out/FV/${fwPrefix}_{CODE,VARS}.fd $fd/FV
  '' + lib.optionalString stdenv.hostPlatform.isx86 ''
    mv -v $out/FV/${fwPrefix}.fd $fd/FV
  '' + lib.optionalString msVarsTemplate ''
    mv -v $out/FV/${fwPrefix}_VARS.ms.fd $fd/FV
    ln -sv $fd/FV/${fwPrefix}_CODE{,.ms}.fd
  '' + lib.optionalString stdenv.hostPlatform.isAarch ''
    mv -v $out/FV/QEMU_{EFI,VARS}.fd $fd/FV
    # Add symlinks for Fedora dir layout: https://src.fedoraproject.org/rpms/edk2/blob/main/f/edk2.spec
    mkdir -vp $fd/AAVMF
    ln -s $fd/FV/AAVMF_CODE.fd $fd/AAVMF/QEMU_EFI-pflash.raw
    ln -s $fd/FV/AAVMF_VARS.fd $fd/AAVMF/vars-template-pflash.raw
  '';

  dontPatchELF = true;

  passthru =
  let
    prefix = "${finalAttrs.finalPackage.fd}/FV/${fwPrefix}";
  in {
    firmware  = "${prefix}_CODE.fd";
    variables = "${prefix}_VARS.fd";
    variablesMs =
      assert msVarsTemplate;
      "${prefix}_VARS.ms.fd";
    # This will test the EFI firmware for the host platform as part of the NixOS Tests setup.
    tests.basic-systemd-boot = nixosTests.systemd-boot.basic;
    tests.secureBoot-systemd-boot = nixosTests.systemd-boot.secureBoot;
    inherit secureBoot systemManagementModeRequired;
  };

  meta = {
    description = "Sample UEFI firmware for QEMU and KVM";
    homepage = "https://github.com/tianocore/tianocore.github.io/wiki/OVMF";
    license = lib.licenses.bsd2;
    platforms = metaPlatforms;
    maintainers = with lib.maintainers; [ adamcstephens raitobezarius mjoerg sigmasquadron ];
    broken = stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64;
  };
})
