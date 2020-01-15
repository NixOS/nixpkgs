{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  pname = "virt-what";
  version = "1.19";

  src = fetchurl {
    url = "https://people.redhat.com/~rjones/virt-what/files/${pname}-${version}.tar.gz";
    sha256 = "00nhwly5q0ps8yv9cy3c2qp8lfshf3s0kdpwiy5zwk3g77z96rwk";
  };

  meta = with lib; {
    description = "Detect if running in a virtual machine and prints its type";
    homepage = "https://people.redhat.com/~rjones/virt-what/";
    maintainers = with maintainers; [ fpletz ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
