{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  pname = "virt-what";
  version = "1.21";

  src = fetchurl {
    url = "https://people.redhat.com/~rjones/virt-what/files/${pname}-${version}.tar.gz";
    sha256 = "0yqz1l4di57d4y1z94yhdmkiykg9a8i7xwkqmd9zsk5a6i9lbjqj";
  };

  meta = with lib; {
    description = "Detect if running in a virtual machine and prints its type";
    homepage = "https://people.redhat.com/~rjones/virt-what/";
    maintainers = with maintainers; [ fpletz ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
