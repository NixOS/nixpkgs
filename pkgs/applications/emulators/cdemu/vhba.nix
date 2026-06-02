{
  lib,
  stdenv,
  fetchurl,
  kernel,
  kernelModuleMakeFlags,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vhba";
  version = "20260313";

  src = fetchurl {
    url = "mirror://sourceforge/cdemu/vhba-module-${finalAttrs.version}.tar.xz";
    hash = "sha256-KTADv12dwrOG2w0F9ZXFVINVpTXW38Bv03n9mLsZAXQ=";
  };

  makeFlags = kernelModuleMakeFlags ++ [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  meta = {
    description = "Provides a Virtual (SCSI) HBA";
    homepage = "https://cdemu.sourceforge.io/about/vhba/";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ bendlas ];
  };
})
