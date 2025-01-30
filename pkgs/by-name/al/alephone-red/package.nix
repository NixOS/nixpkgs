{ alephone, fetchurl }:

alephone.makeWrapper rec {
  pname = "marathon-red";
  version = "0";
  desktopName = "Marathon-Red";

  zip = fetchurl {
    url = "http://files3.bungie.org/trilogy/MarathonRED.zip";
    hash = "sha256-/GGjP0cFTwlndpovsVo4VnuY2TEU9+m2/WnYnanVI9w=";
  };

  meta = {
    description = "Survival horror-esque Marathon conversion";
    homepage = "https://alephone.lhowon.org/scenarios.html";
  };

}
