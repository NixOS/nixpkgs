{stdenv, fetchurl, zlib, alsaLib}:

assert stdenv.system == "i686-linux";

(stdenv.mkDerivation {
  name = "flashplayer-9.0.31.0";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://fpdownload.macromedia.com/get/flashplayer/current/install_flash_player_9_linux.tar.gz;
    sha256 = "0y69n2i8b0zrb5dswhsvb6gls30p42p869vvyvpsg3prwwdrf6z3";
  };

  inherit zlib alsaLib;
}) // {mozillaPlugin = "/lib/mozilla/plugins";}
