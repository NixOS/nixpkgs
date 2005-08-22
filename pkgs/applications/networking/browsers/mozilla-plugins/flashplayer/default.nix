{stdenv, fetchurl, zlib, libXmu}:

(stdenv.mkDerivation {
  name = "flashplayer-7.0r25";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/install_flash_player_7_linux.tar.gz;
    md5 = "79c59a5ea29347e01c8e6575dd054cd1";
  };

  inherit zlib libXmu;
}) // {mozillaPlugin = "/lib/mozilla/plugins";}
