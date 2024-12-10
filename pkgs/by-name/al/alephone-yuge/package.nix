{ alephone, fetchurl }:

alephone.makeWrapper rec {
  pname = "yuge";
  version = "0";
  desktopName = "Marathon-Yuge";

  zip = fetchurl {
    url = "https://lochnits.com/marathon/yuge/files/Mararthon_Yuge.zip";
    sha256 = "sha256-dZHInYThB/4igpAXbUadXwPvh2Fl3XGZ4ficg7IEnNc=";
  };

  meta = {
    description = "30 level Marathon scenario, plus 225 secret levels for many extra hours of gameplay";
    homepage = "https://lochnits.com/marathon/yuge/";
  };
}
