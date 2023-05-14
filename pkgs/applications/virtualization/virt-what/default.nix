{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  pname = "virt-what";
  version = "1.25";

  src = fetchurl {
    url = "https://people.redhat.com/~rjones/virt-what/files/${pname}-${version}.tar.gz";
    sha256 = "sha256-1Py0I2Irr75eK7zYS32SrU1YP0d4siW3LEqBrp/Dxz0=";
  };

  meta = with lib; {
    description = "Detect if running in a virtual machine and prints its type";
    homepage = "https://people.redhat.com/~rjones/virt-what/";
    maintainers = with maintainers; [ fpletz ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
