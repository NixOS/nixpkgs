{ alephone, fetchurl }:

alephone.makeWrapper {
  pname = "marathon-eternal";
  version = "1.2.1";
  desktopName = "Marathon-Eternal";

  zip = fetchurl {
    url = "https://eternal.bungie.org/files/_releases/EternalXv121.zip";
    hash = "sha256-8smVdL7CYbrIzCqu3eqk6KQempKLWuEJ9qWStdWkYWo=";
  };

  sourceRoot = "Eternal 1.2.1";

  meta = {
    description = "Picking up from the end of the Marathon trilogy, you find yourself suddenly ninety-four years in the future, in the year 2905";
    homepage = "http://eternal.bungie.org/";
  };

}
