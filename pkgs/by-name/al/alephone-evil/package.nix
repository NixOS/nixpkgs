{ alephone, fetchurl }:

alephone.makeWrapper rec {
  pname = "marathon-evil";
  version = "0";
  desktopName = "Marathon-Evil";

  zip = fetchurl {
    url = "http://files3.bungie.org/trilogy/MarathonEvil.zip";
    hash = "sha256-Ja3kvg6fCkRWURgw4av1X0iglTkLrozvAqFnceX60SI=";
  };

  meta = {
    description = "First conversion for Marathon Infinity";
    homepage = "https://alephone.lhowon.org/scenarios.html";
  };

}
