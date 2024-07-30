{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  pname = "virt-what";
  version = "1.26";

  src = fetchurl {
    url = "https://people.redhat.com/~rjones/virt-what/files/${pname}-${version}.tar.gz";
    sha256 = "sha256-qoap0xO1yQSK+a2aA4fkr/I4uw6kLzuDARTotQzTFTU=";
  };

  meta = with lib; {
    description = "Detect if running in a virtual machine and prints its type";
    homepage = "https://people.redhat.com/~rjones/virt-what/";
    maintainers = with maintainers; [ fpletz ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    mainProgram = "virt-what";
  };
}
