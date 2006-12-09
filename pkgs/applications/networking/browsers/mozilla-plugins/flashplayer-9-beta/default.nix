{stdenv, fetchurl, zlib}:

(stdenv.mkDerivation {
  name = "flashplayer-9.0.21.78-pre-beta-112006";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://download.macromedia.com/pub/labs/flashplayer9_update/FP9_plugin_beta_112006.tar.gz;
    md5 = "3ab408f85ae6d8180cc913edf97bf3eb";
  };

  inherit zlib;
}) // {mozillaPlugin = "/lib/mozilla/plugins";}
