{stdenv, fetchurl, zlib, alsaLib, curl}:

stdenv.mkDerivation {
  name = if (stdenv.system == "x86_64-linux") then
      "flashplayer-10.0.22.87"
    else
      "flashplayer-10.0.22";

  builder = ./builder.sh;
  
  src = if (stdenv.system == "x86_64-linux") then fetchurl {
    url = http://download.macromedia.com/pub/labs/flashplayer10/libflashplayer-10.0.22.87.linux-x86_64.so.tar.gz;
    sha256 = "eac1d05aa96036819fe8f14f293a2ccc9601e1e32e08ec33e6ed9ed698e76145";
  }
  else fetchurl {
    url = http://fpdownload.macromedia.com/get/flashplayer/current/install_flash_player_10_linux.tar.gz;
    sha256 = "cd29f166c87fecc943e88fe951bb61c56728fab12b4bf343badafa73ea95394e";
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
