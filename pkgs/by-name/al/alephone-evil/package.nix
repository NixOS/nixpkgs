{ alephone, fetchurl, unrar }:

alephone.makeWrapper rec {
  pname = "marathon-evil";
  version = "0";
  desktopName = "Marathon-Evil";

  zip = fetchurl {
    url = "http://files3.bungie.org/trilogy/MarathonEvil.zip";
    sha256 = "08nizbjp2rx10bpqrbhb76as0j2zynmy2c0qa5b482lz1szf9b95";
  };

  meta = {
    description = "First conversion for Marathon Infinity";
    homepage = "https://alephone.lhowon.org/scenarios.html";
  };

}
