{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  name = "virt-what-${version}";
  version = "1.18";

  src = fetchurl {
    url = "https://people.redhat.com/~rjones/virt-what/files/${name}.tar.gz";
    sha256 = "1x32h7i6lh823wj97r5rr2hg1v215kqzly14dwg0mwx62j1dshmw";
  };

  meta = with lib; {
    description = "Detect if running in a virtual machine and prints its type";
    homepage = https://people.redhat.com/~rjones/virt-what/;
    maintainers = with maintainers; [ fpletz ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
