{stdenv, fetchurl, libstdcpp5, glib, pango, atk, gtk, libX11}:

# Note that RealPlayer 10 need libstdc++.so.5, i.e., GCC 3.3, not 3.4.

assert stdenv.system == "i686-linux";

(stdenv.mkDerivation {
  name = "RealPlayer-10.0.8.805-GOLD";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://software-dl.real.com/25ae61d70a6855a52c14/unix/RealPlayer10GOLD.bin;
    md5 = "d28b31261059231a3e93c7466f8153e6";
  };

  makeWrapper = ../../../build-support/make-wrapper/make-wrapper.sh;

  inherit libstdcpp5;
  libPath = [libstdcpp5 glib pango atk gtk libX11];
  
}) // {mozillaPlugin = "/real/mozilla";}
