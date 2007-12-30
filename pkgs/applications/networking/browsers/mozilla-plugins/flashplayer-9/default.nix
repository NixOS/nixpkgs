{stdenv, fetchurl, zlib, alsaLib}:

assert stdenv.system == "i686-linux";

stdenv.mkDerivation {
  name = "flashplayer-9.0.115.0";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://fpdownload.macromedia.com/get/flashplayer/current/install_flash_player_9_linux.tar.gz;
    sha256 = "0yr2n7barlbvqxxzbvgp0pmbwwf7bvjksravqa47yra689jvynr7";
  };

  inherit zlib alsaLib;

  passthru = {
    mozillaPlugin = "/lib/mozilla/plugins";
  };

  meta = {
    description = "Adobe Flash Player browser plugin";
    homepage = http://www.adobe.com/products/flashplayer/;
  };

}
