{stdenv, fetchurl, zlib, alsaLib, curl}:

assert stdenv.system == "i686-linux";

stdenv.mkDerivation {
  name = "flashplayer-10.0.12.36";

  builder = ./builder.sh;
  
  src = fetchurl {
    url = http://fpdownload.macromedia.com/get/flashplayer/current/install_flash_player_10_linux.tar.gz;
    sha256 = "cd3e8fbb05da4a5303f958cb627bc7f3845dd86576a96ab157effc4f0ae65e5d";
  };

  inherit zlib alsaLib;

  passthru = {
    mozillaPlugin = "/lib/mozilla/plugins";
  };

  rpath = "${zlib}/lib:${alsaLib}/lib:${curl}/lib";

  meta = {
    description = "Adobe Flash Player browser plugin";
    homepage = http://www.adobe.com/products/flashplayer/;
  };
}
