{ lib, stdenv, fetchurl, kernel }:

stdenv.mkDerivation rec {
  pname = "vhba";
  version = "20211218";

  src  = fetchurl {
    url = "mirror://sourceforge/cdemu/vhba-module-${version}.tar.xz";
    sha256 = "sha256-csWowcRSgF5M74yv787MLSXOGXrkxnODCCgC5a3Nd7Y=";
  };

  makeFlags = kernel.makeFlags ++ [ "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" "INSTALL_MOD_PATH=$(out)" ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  meta = with lib; {
    description = "Provides a Virtual (SCSI) HBA";
    homepage = "https://cdemu.sourceforge.io/about/vhba/";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ bendlas ];
  };
}
