{
  lib,
  stdenv,
  fetchurl,
  kernel,
  kernelModuleMakeFlags,
}:

stdenv.mkDerivation rec {
  pname = "vhba";
  version = "20250329";

  src = fetchurl {
    url = "mirror://sourceforge/cdemu/vhba-module-${version}.tar.xz";
    hash = "sha256-piog1yDd8M/lpTIo9FE9SY2JwurZ6a8LG2lZ/4EmB14=";
  };

  makeFlags = kernelModuleMakeFlags ++ [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  meta = with lib; {
    description = "Provides a Virtual (SCSI) HBA";
    homepage = "https://cdemu.sourceforge.io/about/vhba/";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ bendlas ];
  };
}
