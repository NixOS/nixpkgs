{
  lib,
  stdenv,
  fetchurl,
  kernel,
}:

stdenv.mkDerivation rec {
  pname = "vhba";
  version = "20240202";

  src = fetchurl {
    url = "mirror://sourceforge/cdemu/vhba-module-${version}.tar.xz";
    hash = "sha256-v1hQ1Lj1AiHKh9c0OpKe2oexkfb1roxhQXRUO1ut3oM=";
  };

  makeFlags = kernel.makeFlags ++ [
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
