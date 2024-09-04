{ alephone, fetchurl }:

alephone.makeWrapper rec {
  pname = "marathon-red";
  version = "0";
  desktopName = "Marathon-Red";

  zip = fetchurl {
    url = "http://files3.bungie.org/trilogy/MarathonRED.zip";
    sha256 = "1p13snlrvn39znvfkxql67crhysn71db2bwsfrkhjkq58wzs6qgw";
  };

  meta = {
    description = "Survival horror-esque Marathon conversion";
    homepage = "https://alephone.lhowon.org/scenarios.html";
  };

}
