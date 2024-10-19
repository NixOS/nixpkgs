{ alephone, fetchurl }:

alephone.makeWrapper rec {
  pname = "marathon-eternal";
  version = "1.2.0";
  desktopName = "Marathon-Eternal";

  zip = fetchurl {
    url = "http://eternal.bungie.org/files/_releases/EternalXv120.zip";
    hash = "sha256-k3F2G2Jc+XhvhidqsX39UqFCfpPo+3Lv+oj1dDXoO+M=";
  };

  sourceRoot = "Eternal 1.2.0";

  meta = {
    description =
      "Picking up from the end of the Marathon trilogy, you find yourself suddenly ninety-four years in the future, in the year 2905";
    homepage = "http://eternal.bungie.org/";
  };

}
