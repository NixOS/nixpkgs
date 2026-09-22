{
  lib,
  edk2,
  util-linux,
  nasm,
  acpica-tools,
  debug ? false,
}:

edk2.mkDerivation "OvmfPkg/IntelTdx/IntelTdxX64.dsc" (finalAttrs: {
  pname = "OVMF-inteltdx";
  version = lib.getVersion edk2;

  __structuredAttrs = true;

  outputs = [
    "out"
    "fd"
  ];

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

  # Only ship the unified firmware image: TDX attests the initial guest
  # memory, so the image is mapped read-only via -bios instead of pflash
  # and the CODE/VARS split is not useful.
  postInstall = ''
    mkdir -vp $fd/FV $fd/share/qemu/firmware
    mv -v $out/FV/OVMF.fd $fd/FV/OVMF.inteltdx.fd
    substitute ${./61-edk2-ovmf-x64-inteltdx.json} \
      $fd/share/qemu/firmware/61-edk2-ovmf-x64-inteltdx.json \
      --subst-var-by firmware "$fd/FV/OVMF.inteltdx.fd"
  '';

  dontPatchELF = true;

  passthru = {
    firmware = "${finalAttrs.finalPackage.fd}/FV/OVMF.inteltdx.fd";
    mergedFirmware = "${finalAttrs.finalPackage.fd}/FV/OVMF.inteltdx.fd";
  };

  meta = {
    description = "UEFI firmware with Intel TDX support";
    homepage = "https://github.com/tianocore/tianocore.github.io/wiki/OVMF";
    license = lib.licenses.bsd2;
    platforms = builtins.filter (lib.hasPrefix "x86_64-") edk2.meta.platforms;
    maintainers = [ lib.maintainers.katexochen ];
  };
})
