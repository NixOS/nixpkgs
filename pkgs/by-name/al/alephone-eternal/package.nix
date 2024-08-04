{ alephone, fetchurl }:

alephone.makeWrapper rec {
  pname = "marathon-eternal";
  version = "1.2.0";
  desktopName = "Marathon-Eternal";

  zip = fetchurl {
    url = "http://eternal.bungie.org/files/_releases/EternalXv120.zip";
    sha256 = "1qrvx0sp9xc8zbpp5yz8jdz458ajzmyv2si7hrppiyawc8dpcwck";
  };

  sourceRoot = "Eternal 1.2.0";

  meta = {
    description =
      "Picking up from the end of the Marathon trilogy, you find yourself suddenly ninety-four years in the future, in the year 2905";
    homepage = "http://eternal.bungie.org/";
  };

}
