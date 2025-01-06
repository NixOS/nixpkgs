{
  lib,
  stdenv,
  fetchurl,
  kernel,
}:

stdenv.mkDerivation rec {
  pname = "vhba";
  version = "20240917";

  src = fetchurl {
    url = "mirror://sourceforge/cdemu/vhba-module-${version}.tar.xz";
    hash = "sha256-zjTLriw2zvjX0Jxfa9QtaHG5tTC7cLTKEA+WSCP+Dpg=";
  };

  makeFlags = kernel.makeFlags ++ [
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
}
