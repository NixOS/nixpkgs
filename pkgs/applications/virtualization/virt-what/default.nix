{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  pname = "virt-what";
  version = "1.24";

  src = fetchurl {
    url = "https://people.redhat.com/~rjones/virt-what/files/${pname}-${version}.tar.gz";
    sha256 = "sha256-C9fllw/y1SwJKIEa4mgnlYQjF/7L5VN0z84EI88uS9Y=";
  };

  meta = with lib; {
    description = "Detect if running in a virtual machine and prints its type";
    homepage = "https://people.redhat.com/~rjones/virt-what/";
    maintainers = with maintainers; [ fpletz ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
