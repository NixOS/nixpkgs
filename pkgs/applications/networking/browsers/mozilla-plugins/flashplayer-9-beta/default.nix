{stdenv, fetchurl, zlib}:

(stdenv.mkDerivation {
  name = "flashplayer-9.0.21.55-pre-beta-101806";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://download.macromedia.com/pub/labs/flashplayer9_update/FP9_plugin_beta_101806.tar.gz;
    md5 = "0b234c5d0eaf254ef8af364fb9ed97f2";
  };

  inherit zlib;
}) // {mozillaPlugin = "/lib/mozilla/plugins";}
