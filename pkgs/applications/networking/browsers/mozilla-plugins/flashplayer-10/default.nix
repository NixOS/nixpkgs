{stdenv, fetchurl, zlib, alsaLib, curl}:

assert stdenv.system == "i686-linux";

stdenv.mkDerivation {
  name = "flashplayer-10.0.12.36";

  builder = ./builder.sh;
  
  src = fetchurl {
    url = http://fpdownload.macromedia.com/get/flashplayer/current/install_flash_player_10_linux.tar.gz;
    sha256 = "0bcn07a3684krqbh6cw08hb8lymm0wijnlcx5bvln44749kzg7wf";
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
