{
  lib,
  edk2,
  util-linux,
  nasm,
  acpica-tools,
  debug ? false,
}:

edk2.mkDerivation "OvmfPkg/AmdSev/AmdSevX64.dsc" (finalAttrs: {
  pname = "OVMF-amdsev";
  version = lib.getVersion edk2;

  outputs = [
    "out"
    "fd"
  ];

  __structuredAttrs = true;

  nativeBuildInputs = [
    util-linux
    nasm
    acpica-tools
  ];
  strictDeps = true;

  hardeningDisable = [
    "format"
    "pic"
    "fortify"
  ];

  buildFlags = lib.optionals debug [ "-D DEBUG_ON_SERIAL_PORT=TRUE" ];
  buildConfig = if debug then "DEBUG" else "RELEASE";

  # The AmdSev platform embeds a grub image, built by the PREBUILD hook
  # (OvmfPkg/AmdSev/Grub/grub.sh). Provide an empty grub.efi instead
  # (the hook keeps an existing, newer grub.efi), like Fedora does.
  # The resulting firmware supports direct kernel boot only.
  postPatch = ''
    touch OvmfPkg/AmdSev/Grub/grub.efi
  '';

  # AmdSevX64 only produces a unified firmware image. There is no
  # CODE/VARS split: SEV-SNP attests the initial guest memory, so the
  # image is mapped read-only via -bios instead of pflash.
  postInstall = ''
    mkdir -vp $fd/FV $fd/share/qemu/firmware
    mv -v $out/FV/OVMF.fd $fd/FV/OVMF.amdsev.fd
    substitute ${./61-edk2-ovmf-x64-amdsev.json} \
      $fd/share/qemu/firmware/61-edk2-ovmf-x64-amdsev.json \
      --subst-var-by firmware "$fd/FV/OVMF.amdsev.fd"
  '';

  dontPatchELF = true;

  passthru = {
    firmware = "${finalAttrs.finalPackage.fd}/FV/OVMF.amdsev.fd";
    mergedFirmware = "${finalAttrs.finalPackage.fd}/FV/OVMF.amdsev.fd";
  };

  meta = {
    description = "UEFI firmware with AMD SEV, SEV-ES and SEV-SNP support, direct kernel boot only";
    homepage = "https://github.com/tianocore/tianocore.github.io/wiki/OVMF";
    license = lib.licenses.bsd2;
    platforms = builtins.filter (lib.hasPrefix "x86_64-") edk2.meta.platforms;
    maintainers = [ lib.maintainers.katexochen ];
  };
})
