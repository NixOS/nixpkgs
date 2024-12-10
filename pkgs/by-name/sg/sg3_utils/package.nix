{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "sg3_utils";
  version = "1.48";

  src = fetchurl {
    url = "https://sg.danny.cz/sg/p/sg3_utils-${version}.tgz";
    sha256 = "sha256-1itsPPIDkPpzVwRDkAhBZtJfHZMqETXEULaf5cKD13M=";
  };

  meta = with lib; {
    homepage = "https://sg.danny.cz/sg/";
    description = "Utilities that send SCSI commands to devices";
    platforms = platforms.linux;
    license = with licenses; [ bsd2 gpl2Plus ];
  };
}
