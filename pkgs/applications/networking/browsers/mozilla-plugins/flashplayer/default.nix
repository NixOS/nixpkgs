{stdenv, fetchurl, zlib, libXmu}:

stdenv.mkDerivation {
  name = "flashplayer-7.0r25";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://fpdownload.macromedia.com/get/shockwave/flash/english/linux/7.0r25/install_flash_player_7_linux.tar.gz;
    md5 = "79c59a5ea29347e01c8e6575dd054cd1";
  };

  inherit zlib libXmu;
}
