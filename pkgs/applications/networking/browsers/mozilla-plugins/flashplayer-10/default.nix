{stdenv, fetchurl, zlib, alsaLib, curl}:

stdenv.mkDerivation {
  name = "flashplayer-10.0.32.18";

  builder = ./builder.sh;
  
  src =
    if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = http://download.macromedia.com/pub/labs/flashplayer10/libflashplayer-10.0.32.18.linux-x86_64.so.tar.gz;
        sha256 = "006k3jvahlq2v34q5mf2y7ghczhy6spsdd69fj120i9yz9zklhpw";
      }
    else
      fetchurl {
        url = http://fpdownload.macromedia.com/get/flashplayer/current/install_flash_player_10_linux.tar.gz;
        sha256 = "1nnswpivn8ymbvqywdw39xf26mn2i65hyqw8lcl77qsv7kbsbbl8";
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
